import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class GetTicket implements UseCase<Ticket, int> {
  final TicketRepository repository;

  GetTicket(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(int ticketId) async {
    return await repository.getTicket(ticketId);
  }
}