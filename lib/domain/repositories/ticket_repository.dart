import 'package:dartz/dartz.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';

abstract class TicketRepository {
  Future<Either<Failure, List<Ticket>>> getTickets({
    int? limit,
    int? offset,
    Map<String, dynamic>? criteria,
  });

  Future<Either<Failure, Ticket>> getTicket(int id);

  Future<Either<Failure, Ticket>> createTicket(Ticket ticket);

  Future<Either<Failure, Ticket>> updateTicket(Ticket ticket);

  Future<Either<Failure, void>> deleteTicket(int id);

  Future<Either<Failure, List<Ticket>>> searchTickets({
    required String query,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, List<Ticket>>> getTicketsByStatus(TicketStatus status);

  Future<Either<Failure, List<Ticket>>> getTicketsByPriority(TicketPriority priority);

  Future<Either<Failure, List<Ticket>>> getTicketsByUser(int userId);

  Future<Either<Failure, List<Ticket>>> getTicketsByCategory(int categoryId);

  Future<Either<Failure, List<Ticket>>> getTicketsByLocation({
    double? latitude,
    double? longitude,
    double? radius,
  });

  Future<Either<Failure, Map<String, int>>> getTicketStatistics();

  Future<Either<Failure, void>> addTicketToFavorites(int ticketId);

  Future<Either<Failure, void>> removeTicketFromFavorites(int ticketId);

  Future<Either<Failure, List<Ticket>>> getFavoriteTickets();

  Future<Either<Failure, void>> cacheTickets(List<Ticket> tickets);

  Future<Either<Failure, List<Ticket>>> getCachedTickets();
}