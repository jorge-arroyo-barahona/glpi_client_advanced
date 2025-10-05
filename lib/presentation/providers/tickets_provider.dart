import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/core/errors/failures.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/get_tickets.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/get_ticket.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/create_ticket.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/update_ticket.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/delete_ticket.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/search_tickets.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/get_tickets_by_status.dart';
import 'package:glpi_client_advanced/domain/usecases/tickets/get_ticket_statistics.dart';

class TicketsState {
  final List<Ticket> tickets;
  final Ticket? selectedTicket;
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final Failure? error;
  final Map<String, int> statistics;
  final String? searchQuery;
  final bool isSearching;

  const TicketsState({
    this.tickets = const [],
    this.selectedTicket,
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.error,
    this.statistics = const {},
    this.searchQuery,
    this.isSearching = false,
  });

  TicketsState copyWith({
    List<Ticket>? tickets,
    Ticket? selectedTicket,
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    Failure? error,
    Map<String, int>? statistics,
    String? searchQuery,
    bool? isSearching,
  }) {
    return TicketsState(
      tickets: tickets ?? this.tickets,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error ?? this.error,
      statistics: statistics ?? this.statistics,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  List<Ticket> get openTickets =>
      tickets.where((ticket) => ticket.isOpen).toList();

  List<Ticket> get closedTickets =>
      tickets.where((ticket) => ticket.isClosed).toList();

  List<Ticket> get solvedTickets =>
      tickets.where((ticket) => ticket.isSolved).toList();

  List<Ticket> get filteredTickets {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return tickets;
    }
    return tickets.where((ticket) {
      return ticket.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
          (ticket.content?.toLowerCase().contains(searchQuery!.toLowerCase()) ?? false);
    }).toList();
  }
}

class TicketsNotifier extends StateNotifier<TicketsState> {
  final GetTickets getTickets;
  final GetTicket getTicket;
  final CreateTicket createTicket;
  final UpdateTicket updateTicket;
  final DeleteTicket deleteTicket;
  final SearchTickets searchTickets;
  final GetTicketsByStatus getTicketsByStatus;
  final GetTicketStatistics getTicketStatistics;

  TicketsNotifier({
    required this.getTickets,
    required this.getTicket,
    required this.createTicket,
    required this.updateTicket,
    required this.deleteTicket,
    required this.searchTickets,
    required this.getTicketsByStatus,
    required this.getTicketStatistics,
  }) : super(const TicketsState());

  Future<void> loadTickets({int? limit, int? offset}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await getTickets(GetTicketsParams(
      limit: limit,
      offset: offset,
    ));

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure,
        );
      },
      (tickets) {
        state = state.copyWith(
          isLoading: false,
          tickets: tickets,
          error: null,
        );
      },
    );
  }

  Future<void> loadTicket(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getTicket(id);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure,
        );
      },
      (ticket) {
        state = state.copyWith(
          isLoading: false,
          selectedTicket: ticket,
          error: null,
        );
      },
    );
  }

  Future<Ticket?> createNewTicket(Ticket ticket) async {
    state = state.copyWith(isCreating: true, error: null);

    final result = await createTicket(ticket);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isCreating: false,
          error: failure,
        );
        return null;
      },
      (newTicket) {
        final updatedTickets = List<Ticket>.from(state.tickets)..insert(0, newTicket);
        state = state.copyWith(
          isCreating: false,
          tickets: updatedTickets,
          selectedTicket: newTicket,
          error: null,
        );
        return newTicket;
      },
    );
  }

  Future<bool> updateExistingTicket(Ticket ticket) async {
    state = state.copyWith(isUpdating: true, error: null);

    final result = await updateTicket(ticket);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          error: failure,
        );
        return false;
      },
      (updatedTicket) {
        final updatedTickets = state.tickets.map((t) {
          return t.id == updatedTicket.id ? updatedTicket : t;
        }).toList();

        state = state.copyWith(
          isUpdating: false,
          tickets: updatedTickets,
          selectedTicket: updatedTicket,
          error: null,
        );
        return true;
      },
    );
  }

  Future<bool> deleteTicketById(int id) async {
    state = state.copyWith(isDeleting: true, error: null);

    final result = await deleteTicket(id);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isDeleting: false,
          error: failure,
        );
        return false;
      },
      (_) {
        final updatedTickets = state.tickets.where((t) => t.id != id).toList();
        state = state.copyWith(
          isDeleting: false,
          tickets: updatedTickets,
          selectedTicket: state.selectedTicket?.id == id ? null : state.selectedTicket,
          error: null,
        );
        return true;
      },
    );
  }

  Future<void> searchTickets(String query, {int? limit, int? offset}) async {
    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: null,
        isSearching: false,
      );
      await loadTickets();
      return;
    }

    state = state.copyWith(
      isSearching: true,
      searchQuery: query,
      error: null,
    );

    final result = await searchTickets(SearchTicketsParams(
      query: query,
      limit: limit,
      offset: offset,
    ));

    result.fold(
      (failure) {
        state = state.copyWith(
          isSearching: false,
          error: failure,
        );
      },
      (tickets) {
        state = state.copyWith(
          isSearching: false,
          tickets: tickets,
          error: null,
        );
      },
    );
  }

  Future<void> loadTicketsByStatus(TicketStatus status) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getTicketsByStatus(status);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure,
        );
      },
      (tickets) {
        state = state.copyWith(
          isLoading: false,
          tickets: tickets,
          error: null,
        );
      },
    );
  }

  Future<void> loadStatistics() async {
    final result = await getTicketStatistics(NoParams());

    result.fold(
      (failure) {
        // Silently fail for statistics
      },
      (statistics) {
        state = state.copyWith(statistics: statistics);
      },
    );
  }

  void selectTicket(Ticket? ticket) {
    state = state.copyWith(selectedTicket: ticket);
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: null,
      isSearching: false,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers for dependencies
final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  // This will be implemented when we create the repository implementation
  throw UnimplementedError('Ticket repository not implemented yet');
});

// Use case providers
final getTicketsProvider = Provider<GetTickets>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return GetTickets(repository);
});

final getTicketProvider = Provider<GetTicket>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return GetTicket(repository);
});

final createTicketProvider = Provider<CreateTicket>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return CreateTicket(repository);
});

final updateTicketProvider = Provider<UpdateTicket>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return UpdateTicket(repository);
});

final deleteTicketProvider = Provider<DeleteTicket>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return DeleteTicket(repository);
});

final searchTicketsProvider = Provider<SearchTickets>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return SearchTickets(repository);
});

final getTicketsByStatusProvider = Provider<GetTicketsByStatus>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return GetTicketsByStatus(repository);
});

final getTicketStatisticsProvider = Provider<GetTicketStatistics>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return GetTicketStatistics(repository);
});

// Main state provider
final ticketsProvider = StateNotifierProvider<TicketsNotifier, TicketsState>((ref) {
  return TicketsNotifier(
    getTickets: ref.watch(getTicketsProvider),
    getTicket: ref.watch(getTicketProvider),
    createTicket: ref.watch(createTicketProvider),
    updateTicket: ref.watch(updateTicketProvider),
    deleteTicket: ref.watch(deleteTicketProvider),
    searchTickets: ref.watch(searchTicketsProvider),
    getTicketsByStatus: ref.watch(getTicketsByStatusProvider),
    getTicketStatistics: ref.watch(getTicketStatisticsProvider),
  );
});

// Convenience selectors
final ticketsListProvider = Provider<List<Ticket>>((ref) {
  return ref.watch(ticketsProvider).tickets;
});

final selectedTicketProvider = Provider<Ticket?>((ref) {
  return ref.watch(ticketsProvider).selectedTicket;
});

final ticketsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(ticketsProvider).isLoading;
});

final ticketsErrorProvider = Provider<Failure?>((ref) {
  return ref.watch(ticketsProvider).error;
});

final ticketStatisticsProvider = Provider<Map<String, int>>((ref) {
  return ref.watch(ticketsProvider).statistics;
});

final filteredTicketsProvider = Provider<List<Ticket>>((ref) {
  return ref.watch(ticketsProvider).filteredTickets;
});