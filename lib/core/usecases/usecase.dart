import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}