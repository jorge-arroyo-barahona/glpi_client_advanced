import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class CreateTicket implements UseCase<Ticket, Ticket> {
  final TicketRepository repository;

  CreateTicket(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(Ticket ticket) async {
    return await repository.createTicket(ticket);
  }
}