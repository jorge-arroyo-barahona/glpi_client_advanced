import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class GetTicketsByStatus implements UseCase<List<Ticket>, TicketStatus> {
  final TicketRepository repository;

  GetTicketsByStatus(this.repository);

  @override
  Future<Either<Failure, List<Ticket>>> call(TicketStatus status) async {
    return await repository.getTicketsByStatus(status);
  }
}