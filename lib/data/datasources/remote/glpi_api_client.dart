import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:glpi_client_advanced/core/constants/api_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';
import 'package:glpi_client_advanced/data/models/ticket_model.dart';
import 'package:glpi_client_advanced/data/models/user_model.dart';
import 'package:glpi_client_advanced/data/models/session_model.dart';
import 'package:glpi_client_advanced/data/models/response_model.dart';

class GlpiApiClient {
  final Dio _dio;
  String? _sessionToken;
  String? _appToken;

  GlpiApiClient({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
          },
        )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authentication headers if available
        if (_appToken != null) {
          options.headers[ApiConstants.appTokenHeader] = _appToken;
        }
        if (_sessionToken != null) {
          options.headers[ApiConstants.sessionTokenHeader] = _sessionToken;
        }
        
        // Log request for debugging
        if (kDebugMode) {
          print('API Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
        }
        
        handler.next(options);
      },
      onResponse: (response, handler) {
        // Log response for debugging
        if (kDebugMode) {
          print('API Response: ${response.statusCode} ${response.requestOptions.uri}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        // Log error for debugging
        if (kDebugMode) {
          print('API Error: ${error.response?.statusCode} ${error.requestOptions.uri}');
          print('Error: ${error.message}');
        }
        handler.next(error);
      },
    ));

    // Retry interceptor
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: ApiConstants.maxRetries,
        retryDelay: ApiConstants.retryDelay,
        retryableExtraStatuses: {401, 403, 429},
      ),
    );
  }

  // Authentication methods
  Future<SessionModel> initSession({
    required String appToken,
    String? userToken,
    String? login,
    String? password,
  }) async {
    try {
      _appToken = appToken;
      
      final queryParameters = <String, dynamic>{};
      
      if (userToken != null) {
        queryParameters['user_token'] = userToken;
      } else if (login != null && password != null) {
        queryParameters['login'] = login;
        queryParameters['password'] = password;
      } else {
        throw ValidationException(
          'Either user_token or login/password must be provided',
        );
      }

      final response = await _dio.get(
        ApiConstants.initSession,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final sessionData = response.data as Map<String, dynamic>;
        _sessionToken = sessionData['session_token'] as String?;
        
        if (_sessionToken == null) {
          throw AuthenticationException(
            'No session token received from GLPI API',
          );
        }

        return SessionModel.fromJson(sessionData);
      } else {
        throw AuthenticationException(
          'Failed to initialize session',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(
          'Invalid credentials',
          details: e.response?.data.toString(),
        );
      } else if (e.response?.statusCode == 400) {
        throw ValidationException(
          'Invalid request parameters',
          details: e.response?.data.toString(),
        );
      } else {
        throw NetworkException(
          'Network error during authentication',
          details: e.message,
        );
      }
    }
  }

  Future<void> killSession() async {
    try {
      if (_sessionToken == null) {
        return;
      }

      final response = await _dio.get(ApiConstants.killSession);
      
      if (response.statusCode == 200) {
        _sessionToken = null;
      } else {
        throw ServerException(
          'Failed to kill session',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error during session termination',
        details: e.message,
      );
    }
  }

  // Ticket methods
  Future<List<TicketModel>> getTickets({
    int? limit,
    int? offset,
    Map<String, dynamic>? criteria,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'range': '${offset ?? 0}-${(offset ?? 0) + (limit ?? ApiConstants.defaultLimit) - 1}',
      };

      if (criteria != null) {
        queryParameters.addAll(criteria);
      }

      final response = await _dio.get(
        '/${ApiConstants.entityTicket}',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => TicketModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(
          'Failed to fetch tickets',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while fetching tickets',
        details: e.message,
      );
    }
  }

  Future<TicketModel> getTicket(int id) async {
    try {
      final response = await _dio.get('/${ApiConstants.entityTicket}/$id');

      if (response.statusCode == 200) {
        return TicketModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw ValidationException(
          'Ticket not found',
          details: 'Ticket with ID $id does not exist',
        );
      } else {
        throw ServerException(
          'Failed to fetch ticket',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while fetching ticket',
        details: e.message,
      );
    }
  }

  Future<TicketModel> createTicket(TicketModel ticket) async {
    try {
      final response = await _dio.post(
        '/${ApiConstants.entityTicket}',
        data: ticket.toJson(),
      );

      if (response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final ticketId = responseData['id'] as int;
        return getTicket(ticketId);
      } else {
        throw ServerException(
          'Failed to create ticket',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while creating ticket',
        details: e.message,
      );
    }
  }

  Future<TicketModel> updateTicket(int id, TicketModel ticket) async {
    try {
      final response = await _dio.put(
        '/${ApiConstants.entityTicket}/$id',
        data: ticket.toJson(),
      );

      if (response.statusCode == 200) {
        return getTicket(id);
      } else {
        throw ServerException(
          'Failed to update ticket',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while updating ticket',
        details: e.message,
      );
    }
  }

  Future<void> deleteTicket(int id) async {
    try {
      final response = await _dio.delete('/${ApiConstants.entityTicket}/$id');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerException(
          'Failed to delete ticket',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while deleting ticket',
        details: e.message,
      );
    }
  }

  // User methods
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConstants.getFullSession);

      if (response.statusCode == 200) {
        final sessionData = response.data as Map<String, dynamic>;
        final userData = sessionData['glpiactiveprofile'] as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          'Failed to fetch current user',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while fetching current user',
        details: e.message,
      );
    }
  }

  // Search methods
  Future<SearchResponseModel> searchItems({
    required String itemType,
    required String searchText,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'itemtype': itemType,
        'searchText': searchText,
        'start': offset ?? 0,
        'limit': limit ?? ApiConstants.defaultLimit,
      };

      final response = await _dio.get(
        ApiConstants.searchItems,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return SearchResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          'Failed to search items',
          details: response.data.toString(),
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw NetworkException(
        'Network error while searching items',
        details: e.message,
      );
    }
  }

  // Utility methods
  void setSessionToken(String token) {
    _sessionToken = token;
  }

  void setAppToken(String token) {
    _appToken = token;
  }

  String? get sessionToken => _sessionToken;
  String? get appToken => _appToken;
  bool get isAuthenticated => _sessionToken != null;

  // Configuration methods
  Future<void> updateBaseUrl(String newBaseUrl) async {
    _dio.options.baseUrl = newBaseUrl;
  }

  void updateTimeout(Duration timeout) {
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
    _dio.options.sendTimeout = timeout;
  }
}

// Retry interceptor implementation
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String) logPrint;
  final int retries;
  final Duration retryDelay;
  final Set<int> retryableExtraStatuses;

  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableExtraStatuses = const {401, 403, 429},
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && err.requestOptions.extra['retry_count'] < retries) {
      err.requestOptions.extra['retry_count'] = (err.requestOptions.extra['retry_count'] ?? 0) + 1;
      
      logPrint('Retrying request (${err.requestOptions.extra['retry_count']}/$retries)');
      
      await Future.delayed(retryDelay);
      
      try {
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue to next interceptor or error handler
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type != DioExceptionType.cancel &&
           err.type != DioExceptionType.badResponse &&
           (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            (err.response?.statusCode != null && 
             (err.response!.statusCode! >= 500 || 
              retryableExtraStatuses.contains(err.response!.statusCode!))));
  }
}

const bool kDebugMode = bool.fromEnvironment('dart.vm.product') == false;