import 'exceptions.dart';

abstract class Failure {
  final String message;
  final String? details;
  final int? code;

  const Failure(this.message, {this.details, this.code});

  @override
  String toString() => 'Failure: $message${details != null ? ' - $details' : ''}';
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory ServerFailure.fromException(ServerException exception) =>
      ServerFailure(exception.message, details: exception.details, code: exception.code);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory NetworkFailure.fromException(NetworkException exception) =>
      NetworkFailure(exception.message, details: exception.details, code: exception.code);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory AuthenticationFailure.fromException(AuthenticationException exception) =>
      AuthenticationFailure(exception.message, details: exception.details, code: exception.code);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory CacheFailure.fromException(CacheException exception) =>
      CacheFailure(exception.message, details: exception.details, code: exception.code);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory ValidationFailure.fromException(ValidationException exception) =>
      ValidationFailure(exception.message, details: exception.details, code: exception.code);
}

class LocationFailure extends Failure {
  const LocationFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory LocationFailure.fromException(LocationException exception) =>
      LocationFailure(exception.message, details: exception.details, code: exception.code);
}

class AIFailure extends Failure {
  const AIFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory AIFailure.fromException(AIException exception) =>
      AIFailure(exception.message, details: exception.details, code: exception.code);
}

class LocalAwarenessFailure extends Failure {
  const LocalAwarenessFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory LocalAwarenessFailure.fromException(LocalAwarenessException exception) =>
      LocalAwarenessFailure(exception.message, details: exception.details, code: exception.code);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message, {String? details, int? code})
      : super(message, details: details, code: code);

  factory UnknownFailure.fromException(Exception exception) =>
      UnknownFailure(exception.toString());
}