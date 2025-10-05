import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class UpdateTicket implements UseCase<Ticket, Ticket> {
  final TicketRepository repository;

  UpdateTicket(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(Ticket ticket) async {
    return await repository.updateTicket(ticket);
  }
}