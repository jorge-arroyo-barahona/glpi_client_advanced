class ApiConstants {
  static const String baseUrl = 'http://your-glpi-server.com/apirest.php';
  static const String appTokenHeader = 'App-Token';
  static const String sessionTokenHeader = 'Session-Token';
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentTypeJson = 'application/json';
  
  // API Endpoints
  static const String initSession = '/initSession';
  static const String killSession = '/killSession';
  static const String getMyProfiles = '/getMyProfiles';
  static const String getActiveProfile = '/getActiveProfile';
  static const String changeActiveProfile = '/changeActiveProfile';
  static const String getMyEntities = '/getMyEntities';
  static const String getActiveEntities = '/getActiveEntities';
  static const String changeActiveEntities = '/changeActiveEntities';
  static const String getFullSession = '/getFullSession';
  static const String getMultipleItems = '/getMultipleItems';
  static const String listSearchOptions = '/listSearchOptions';
  static const String searchItems = '/search';
  
  // Entity types
  static const String entityTickets = 'Ticket';
  static const String entityUsers = 'User';
  static const String entityGroups = 'Group';
  static const String entityLocations = 'Location';
  static const String entityITILCategory = 'ITILCategory';
  static const String entityEntity = 'Entity';
  
  // Default query parameters
  static const int defaultLimit = 50;
  static const int maxLimit = 1000;
  
  // Cache durations
  static const Duration cacheTimeout = Duration(minutes: 5);
  static const Duration sessionTimeout = Duration(hours: 24);
  
  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}