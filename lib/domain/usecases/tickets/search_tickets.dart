import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/core/usecases/usecase.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/repositories/ticket_repository.dart';

class SearchTickets implements UseCase<List<Ticket>, SearchTicketsParams> {
  final TicketRepository repository;

  SearchTickets(this.repository);

  @override
  Future<Either<Failure, List<Ticket>>> call(SearchTicketsParams params) async {
    return await repository.searchTickets(
      query: params.query,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class SearchTicketsParams {
  final String query;
  final int? limit;
  final int? offset;

  const SearchTicketsParams({
    required this.query,
    this.limit,
    this.offset,
  });
}