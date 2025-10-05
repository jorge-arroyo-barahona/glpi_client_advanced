abstract class GlpiException implements Exception {
  final String message;
  final String? details;
  final int? code;

  const GlpiException(this.message, {this.details, this.code});

  @override
  String toString() => 'GLPI Error: $message${details != null ? ' - $details' : ''}';
}

class AuthenticationException extends GlpiException {
  const AuthenticationException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class NetworkException extends GlpiException {
  const NetworkException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class ServerException extends GlpiException {
  const ServerException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class CacheException extends GlpiException {
  const CacheException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class ValidationException extends GlpiException {
  const ValidationException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class LocationException extends GlpiException {
  const LocationException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class AIException extends GlpiException {
  const AIException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}

class LocalAwarenessException extends GlpiException {
  const LocalAwarenessException(String message, {String? details, int? code})
      : super(message, details: details, code: code);
}