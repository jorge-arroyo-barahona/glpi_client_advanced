import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/presentation/providers/auth_provider.dart';
import 'package:glpi_client_advanced/presentation/providers/tickets_provider.dart';
import 'package:glpi_client_advanced/presentation/widgets/ticket_card.dart';
import 'package:glpi_client_advanced/presentation/widgets/search_bar.dart';
import 'package:glpi_client_advanced/presentation/widgets/loading_indicator.dart';
import 'package:glpi_client_advanced/presentation/widgets/error_message.dart';
import 'package:glpi_client_advanced/presentation/widgets/empty_state_message.dart';
import 'package:glpi_client_advanced/presentation/widgets/ai_assistant.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showAIAssistant = false;
  String _searchQuery = '';
  TicketStatus? _selectedStatus;
  TicketPriority? _selectedPriority;

  @override
  void initState() {
    super.initState();
    // Load tickets when page loads
    Future.microtask(() {
      ref.read(ticketsProvider.notifier).loadTickets();
      ref.read(ticketsProvider.notifier).loadStatistics();
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    
    if (query.isEmpty) {
      ref.read(ticketsProvider.notifier).clearSearch();
    } else {
      ref.read(ticketsProvider.notifier).searchTickets(query);
    }
  }

  void _handleStatusFilter(TicketStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    
    if (status != null) {
      ref.read(ticketsProvider.notifier).loadTicketsByStatus(status);
    } else {
      ref.read(ticketsProvider.notifier).loadTickets();
    }
  }

  void _handlePriorityFilter(TicketPriority? priority) {
    setState(() {
      _selectedPriority = priority;
    });
    
    if (priority != null) {
      ref.read(ticketsProvider.notifier).loadTickets(criteria: {
        'criteria': [
          {
            'field': 3, // Priority field
            'searchtype': 'equals',
            'value': priority.value,
          }
        ]
      });
    } else {
      ref.read(ticketsProvider.notifier).loadTickets();
    }
  }

  void _handleTicketTap(Ticket ticket) {
    // Navigate to ticket detail page
    Navigator.pushNamed(
      context,
      '/ticket/${ticket.id}',
      arguments: ticket,
    );
  }

  void _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  void _toggleAIAssistant() {
    setState(() {
      _showAIAssistant = !_showAIAssistant;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final ticketsState = ref.watch(ticketsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GLPI Tickets'),
        actions: [
          // AI Assistant Toggle
          IconButton(
            icon: Icon(
              _showAIAssistant ? Icons.smart_toy : Icons.smart_toy_outlined,
              color: _showAIAssistant ? theme.colorScheme.primary : null,
            ),
            onPressed: _toggleAIAssistant,
            tooltip: 'AI Assistant',
          ),
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: ticketsState.isLoading
                ? null
                : () {
                    ref.read(ticketsProvider.notifier).loadTickets();
                  },
            tooltip: 'Refresh',
          ),
          // User Menu
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                authState.userName?.substring(0, 1).toUpperCase() ?? '?',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.pushNamed(context, '/profile');
                  break;
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
                case 'logout':
                  _handleLogout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(authState.userName ?? 'User'),
                  subtitle: Text('View Profile'),
                  dense: true,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('Settings'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: theme.colorScheme.error),
                  title: Text('Logout'),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Search Bar
              SearchBar(
                hintText: 'Search tickets...',
                onSearch: _handleSearch,
                showFilters: true,
                filterActions: [
                  SearchFilterChip(
                    label: 'All',
                    isSelected: _selectedStatus == null,
                    onTap: () => _handleStatusFilter(null),
                  ),
                  SearchFilterChip(
                    label: 'New',
                    isSelected: _selectedStatus == TicketStatus.newTicket,
                    onTap: () => _handleStatusFilter(TicketStatus.newTicket),
                  ),
                  SearchFilterChip(
                    label: 'Assigned',
                    isSelected: _selectedStatus == TicketStatus.assigned,
                    onTap: () => _handleStatusFilter(TicketStatus.assigned),
                  ),
                  SearchFilterChip(
                    label: 'Pending',
                    isSelected: _selectedStatus == TicketStatus.pending,
                    onTap: () => _handleStatusFilter(TicketStatus.pending),
                  ),
                  SearchFilterChip(
                    label: 'Solved',
                    isSelected: _selectedStatus == TicketStatus.solved,
                    onTap: () => _handleStatusFilter(TicketStatus.solved),
                  ),
                ],
              ),
              
              // Statistics
              if (ticketsState.statistics.isNotEmpty)
                _buildStatisticsCard(theme, ticketsState.statistics),
              
              // Tickets List
              Expanded(
                child: _buildTicketsList(theme, ticketsState),
              ),
            ],
          ),
          
          // AI Assistant Overlay
          if (_showAIAssistant)
            Positioned(
              right: 16,
              bottom: 16,
              child: AIAssistant(
                onClose: () {
                  setState(() {
                    _showAIAssistant = false;
                  });
                },
                onSuggestionSelected: (suggestion) {
                  _handleSearch(suggestion);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-ticket');
        },
        child: const Icon(Icons.add),
        tooltip: 'Create New Ticket',
      ),
    );
  }

  Widget _buildStatisticsCard(ThemeData theme, Map<String, int> statistics) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Statistics',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(theme, 'Total', statistics['total'] ?? 0, Colors.blue),
                _buildStatItem(theme, 'New', statistics['new'] ?? 0, Colors.red),
                _buildStatItem(theme, 'Open', (statistics['assigned'] ?? 0) + (statistics['planned'] ?? 0) + (statistics['pending'] ?? 0), Colors.orange),
                _buildStatItem(theme, 'Solved', statistics['solved'] ?? 0, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketsList(ThemeData theme, TicketsState state) {
    if (state.isLoading && state.tickets.isEmpty) {
      return const LoadingIndicator(message: 'Loading tickets...');
    }

    if (state.error != null && state.tickets.isEmpty) {
      return ErrorMessage(
        message: 'Failed to load tickets',
        details: state.error!.message,
        onRetry: () {
          ref.read(ticketsProvider.notifier).loadTickets();
        },
      );
    }

    if (state.tickets.isEmpty) {
      return EmptyStateMessage(
        message: 'No tickets found',
        description: _searchQuery.isNotEmpty
            ? 'No tickets match your search "$searchQuery"'
            : 'Try adjusting your filters or create a new ticket',
        icon: Icons.inbox,
        onAction: () {
          Navigator.pushNamed(context, '/create-ticket');
        },
        actionText: 'Create Ticket',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(ticketsProvider.notifier).loadTickets();
      },
      child: ListView.builder(
        itemCount: state.tickets.length,
        itemBuilder: (context, index) {
          final ticket = state.tickets[index];
          return TicketCard(
            ticket: ticket,
            onTap: () => _handleTicketTap(ticket),
            isSelected: state.selectedTicket?.id == ticket.id,
          );
        },
      ),
    );
  }
}