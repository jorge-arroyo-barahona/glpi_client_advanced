import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class GetTickets implements UseCase<List<Ticket>, GetTicketsParams> {
  final TicketRepository repository;

  GetTickets(this.repository);

  @override
  Future<Either<Failure, List<Ticket>>> call(GetTicketsParams params) async {
    return await repository.getTickets(
      limit: params.limit,
      offset: params.offset,
      criteria: params.criteria,
    );
  }
}

class GetTicketsParams {
  final int? limit;
  final int? offset;
  final Map<String, dynamic>? criteria;

  const GetTicketsParams({
    this.limit,
    this.offset,
    this.criteria,
  });
}