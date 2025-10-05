class AppConstants {
  // App info
  static const String appName = 'GLPI Advanced Client';
  static const String appVersion = '2.0.0';
  static const String appDescription = 'Advanced multiplatform GLPI client with AI integration';
  
  // Storage keys
  static const String keyAppToken = 'glpi_app_token';
  static const String keySessionToken = 'glpi_session_token';
  static const String keyUserProfile = 'glpi_user_profile';
  static const String keyUserPreferences = 'glpi_user_preferences';
  static const String keyLastSync = 'glpi_last_sync';
  static const String keyCachedData = 'glpi_cached_data';
  static const String keyGeolocationEnabled = 'glpi_geolocation_enabled';
  static const String keyAIEnabled = 'glpi_ai_enabled';
  static const String keyThemeMode = 'glpi_theme_mode';
  static const String keyLanguage = 'glpi_language';
  static const String keyNotificationsEnabled = 'glpi_notifications_enabled';
  
  // Database
  static const String databaseName = 'glpi_client.db';
  static const int databaseVersion = 1;
  
  // AI Configuration
  static const String aiApiKey = 'YOUR_AI_API_KEY_HERE';
  static const String aiBaseUrl = 'https://api.openai.com/v1';
  static const String aiModel = 'gpt-4';
  static const Duration aiTimeout = Duration(seconds: 30);
  
  // Geographic location
  static const double defaultLatitude = 40.4168;
  static const double defaultLongitude = -3.7038;
  static const double locationAccuracy = 10.0;
  static const Duration locationTimeout = Duration(seconds: 10);
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const int maxRecentItems = 10;
  static const int maxSearchHistory = 20;
  
  // File limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf',
    'text/plain',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ];
  
  // Sync intervals
  static const Duration autoSyncInterval = Duration(minutes: 5);
  static const Duration manualSyncTimeout = Duration(minutes: 2);
  
  // Error reporting
  static const String sentryDsn = 'YOUR_SENTRY_DSN_HERE';
  static const bool enableErrorReporting = false;
}