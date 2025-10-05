import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class DeleteTicket implements UseCase<void, int> {
  final TicketRepository repository;

  DeleteTicket(this.repository);

  @override
  Future<Either<Failure, void>> call(int ticketId) async {
    return await repository.deleteTicket(ticketId);
  }
}