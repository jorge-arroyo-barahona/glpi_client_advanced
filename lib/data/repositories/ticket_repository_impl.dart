import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/constants/api_constants.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/data/datasources/local/database_helper.dart';
import 'package:glpi_client_advanced/data/datasources/local/shared_preferences_helper.dart';
import 'package:glpi_client_advanced/data/datasources/remote/glpi_api_client.dart';
import 'package:glpi_client_advanced/data/models/ticket_model.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final GlpiApiClient apiClient;
  final DatabaseHelper databaseHelper;
  final SharedPreferencesHelper sharedPreferencesHelper;

  TicketRepositoryImpl({
    required this.apiClient,
    required this.databaseHelper,
    required this.sharedPreferencesHelper,
  });

  @override
  Future<Either<Failure, List<Ticket>>> getTickets({
    int? limit,
    int? offset,
    Map<String, dynamic>? criteria,
  }) async {
    try {
      // First try to get from cache if offline or recent
      final cachedTickets = await _getCachedTicketsIfValid();
      if (cachedTickets != null && cachedTickets.isNotEmpty) {
        return Right(cachedTickets);
      }

      // Fetch from API
      final ticketModels = await apiClient.getTickets(
        limit: limit,
        offset: offset,
        criteria: criteria,
      );

      final tickets = ticketModels.map((model) => model.toEntity()).toList();

      // Cache the results
      await _cacheTickets(tickets);

      return Right(tickets);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NetworkException catch (e) {
      // Try to return cached data if network fails
      final cachedTickets = await _getCachedTickets();
      if (cachedTickets.isNotEmpty) {
        return Right(cachedTickets);
      }
      return Left(NetworkFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Ticket>> getTicket(int id) async {
    try {
      // Try cache first
      final cachedTicket = await databaseHelper.getTicket(id);
      if (cachedTicket != null) {
        return Right(cachedTicket);
      }

      // Fetch from API
      final ticketModel = await apiClient.getTicket(id);
      final ticket = ticketModel.toEntity();

      // Cache the ticket
      await databaseHelper.insertTicket(ticket);

      return Right(ticket);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Ticket>> createTicket(Ticket ticket) async {
    try {
      final ticketModel = TicketModel.fromEntity(ticket);
      final createdTicketModel = await apiClient.createTicket(ticketModel);
      final createdTicket = createdTicketModel.toEntity();

      // Cache the created ticket
      await databaseHelper.insertTicket(createdTicket);

      return Right(createdTicket);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } on ValidationException catch (e) {
      return Left(ValidationFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Ticket>> updateTicket(Ticket ticket) async {
    try {
      final ticketModel = TicketModel.fromEntity(ticket);
      final updatedTicketModel = await apiClient.updateTicket(ticket.id, ticketModel);
      final updatedTicket = updatedTicketModel.toEntity();

      // Update cache
      await databaseHelper.updateTicket(updatedTicket);

      return Right(updatedTicket);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } on ValidationException catch (e) {
      return Left(ValidationFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTicket(int id) async {
    try {
      await apiClient.deleteTicket(id);

      // Remove from cache
      await databaseHelper.deleteTicket(id);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> searchTickets({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await apiClient.searchItems(
        itemType: ApiConstants.entityTickets,
        searchText: query,
        limit: limit,
        offset: offset,
      );

      final tickets = response.data.map((json) {
        // Convert search result to ticket model
        return TicketModel.fromJson(json as Map<String, dynamic>).toEntity();
      }).toList();

      return Right(tickets);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> getTicketsByStatus(TicketStatus status) async {
    return getTickets(criteria: {
      'criteria': [
        {
          'field': 12, // Status field
          'searchtype': 'equals',
          'value': status.value,
        }
      ]
    });
  }

  @override
  Future<Either<Failure, List<Ticket>>> getTicketsByPriority(TicketPriority priority) async {
    return getTickets(criteria: {
      'criteria': [
        {
          'field': 3, // Priority field
          'searchtype': 'equals',
          'value': priority.value,
        }
      ]
    });
  }

  @override
  Future<Either<Failure, List<Ticket>>> getTicketsByUser(int userId) async {
    return getTickets(criteria: {
      'criteria': [
        {
          'field': 4, // Requester field
          'searchtype': 'equals',
          'value': userId,
        }
      ]
    });
  }

  @override
  Future<Either<Failure, List<Ticket>>> getTicketsByCategory(int categoryId) async {
    return getTickets(criteria: {
      'criteria': [
        {
          'field': 7, // ITIL Category field
          'searchtype': 'equals',
          'value': categoryId,
        }
      ]
    });
  }

  @override
  Future<Either<Failure, List<Ticket>>> getTicketsByLocation({
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      final tickets = await databaseHelper.getTicketsByLocation(
        latitude: latitude,
        longitude: longitude,
        radius: radius ?? 1000, // Default 1km radius
      );
      return Right(tickets);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getTicketStatistics() async {
    try {
      final stats = await databaseHelper.getTicketStatistics();
      return Right(stats);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTicketToFavorites(int ticketId) async {
    try {
      await sharedPreferencesHelper.addFavoriteTicket(ticketId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeTicketFromFavorites(int ticketId) async {
    try {
      await sharedPreferencesHelper.removeFavoriteTicket(ticketId);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> getFavoriteTickets() async {
    try {
      final favoriteIds = await sharedPreferencesHelper.getFavoriteTickets();
      final tickets = await databaseHelper.getTicketsByIds(favoriteIds);
      return Right(tickets);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheTickets(List<Ticket> tickets) async {
    try {
      await _cacheTickets(tickets);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> getCachedTickets() async {
    try {
      final tickets = await _getCachedTickets();
      return Right(tickets);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  // Private helper methods
  Future<void> _cacheTickets(List<Ticket> tickets) async {
    await databaseHelper.insertTickets(tickets);
    await sharedPreferencesHelper.setLastSyncDate(DateTime.now());
  }

  Future<List<Ticket>> _getCachedTickets() async {
    return await databaseHelper.getAllTickets();
  }

  Future<List<Ticket>?> _getCachedTicketsIfValid() async {
    final lastSync = await sharedPreferencesHelper.getLastSyncDate();
    if (lastSync != null) {
      final cacheAge = DateTime.now().difference(lastSync);
      if (cacheAge < ApiConstants.cacheTimeout) {
        return await databaseHelper.getAllTickets();
      }
    }
    return null;
  }
}