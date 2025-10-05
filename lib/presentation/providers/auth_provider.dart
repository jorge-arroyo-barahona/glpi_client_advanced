import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/data/datasources/remote/glpi_api_client.dart';
import 'package:glpi_client_advanced/data/datasources/local/shared_preferences_helper.dart';
import 'package:glpi_client_advanced/data/models/session_model.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? sessionToken;
  final String? appToken;
  final String? userId;
  final String? userName;
  final Failure? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.sessionToken,
    this.appToken,
    this.userId,
    this.userName,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? sessionToken,
    String? appToken,
    String? userId,
    String? userName,
    Failure? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      sessionToken: sessionToken ?? this.sessionToken,
      appToken: appToken ?? this.appToken,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final GlpiApiClient apiClient;
  final SharedPreferencesHelper sharedPreferencesHelper;

  AuthNotifier({
    required this.apiClient,
    required this.sharedPreferencesHelper,
  }) : super(const AuthState()) {
    _loadStoredTokens();
  }

  Future<void> _loadStoredTokens() async {
    try {
      final appToken = await sharedPreferencesHelper.getAppToken();
      final sessionToken = await sharedPreferencesHelper.getSessionToken();
      
      if (appToken != null && sessionToken != null) {
        apiClient.setAppToken(appToken);
        apiClient.setSessionToken(sessionToken);
        
        state = state.copyWith(
          isAuthenticated: true,
          appToken: appToken,
          sessionToken: sessionToken,
        );
        
        // Verify session is still valid
        await verifySession();
      }
    } catch (e) {
      state = state.copyWith(error: Failure('Failed to load stored tokens'));
    }
  }

  Future<void> login({
    required String appToken,
    String? userToken,
    String? login,
    String? password,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Save app token
      await sharedPreferencesHelper.setAppToken(appToken);
      apiClient.setAppToken(appToken);

      // Initialize session
      final session = await apiClient.initSession(
        appToken: appToken,
        userToken: userToken,
        login: login,
        password: password,
      );

      // Save session token
      await sharedPreferencesHelper.setSessionToken(session.sessionToken);
      
      // Get user info
      final user = await apiClient.getCurrentUser();

      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        sessionToken: session.sessionToken,
        appToken: appToken,
        userId: user.id.toString(),
        userName: user.displayName,
        error: null,
      );
    } on Failure catch (failure) {
      state = state.copyWith(
        isLoading: false,
        error: failure,
        isAuthenticated: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: Failure('An unexpected error occurred: ${e.toString()}'),
        isAuthenticated: false,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      // Kill session on server
      await apiClient.killSession();
    } catch (e) {
      // Continue with local logout even if server logout fails
    }

    // Clear local data
    await sharedPreferencesHelper.clearAuthentication();
    
    // Reset API client
    apiClient.setSessionToken(null);
    
    state = const AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }

  Future<void> verifySession() async {
    try {
      // Try to get current user to verify session
      await apiClient.getCurrentUser();
      // If successful, session is valid
    } catch (e) {
      // Session is invalid, logout
      await logout();
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final sharedPreferencesHelper = ref.watch(sharedPreferencesHelperProvider);
  
  return AuthNotifier(
    apiClient: apiClient,
    sharedPreferencesHelper: sharedPreferencesHelper,
  );
});

// Dependencies
final apiClientProvider = Provider<GlpiApiClient>((ref) {
  return GlpiApiClient();
});

final sharedPreferencesHelperProvider = Provider<SharedPreferencesHelper>((ref) {
  return SharedPreferencesHelper();
});

// Auth state selectors
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<Failure?>((ref) {
  return ref.watch(authProvider).error;
});

final currentUserProvider = Provider<AuthState>((ref) {
  return ref.watch(authProvider);
});