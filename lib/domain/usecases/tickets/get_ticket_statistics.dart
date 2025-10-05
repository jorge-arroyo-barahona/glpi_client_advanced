import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class GetTicketStatistics implements UseCase<Map<String, int>, NoParams> {
  final TicketRepository repository;

  GetTicketStatistics(this.repository);

  @override
  Future<Either<Failure, Map<String, int>>> call(NoParams params) async {
    return await repository.getTicketStatistics();
  }
}