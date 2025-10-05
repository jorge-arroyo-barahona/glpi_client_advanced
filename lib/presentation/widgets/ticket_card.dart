import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';

class TicketCard extends ConsumerWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showActions;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isSelected ? 4 : 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.defaultPadding / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        side: isSelected
            ? BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 8),
              _buildTitle(theme),
              if (ticket.content != null) ...[
                const SizedBox(height: 8),
                _buildContent(theme),
              ],
              const SizedBox(height: 12),
              _buildFooter(theme),
              if (showActions && (ticket.hasLocation || ticket.usersIdAssign != null)) ...[
                const SizedBox(height: 8),
                _buildActions(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        _buildStatusChip(theme),
        const SizedBox(width: 8),
        _buildPriorityChip(theme),
        const Spacer(),
        _buildTicketId(theme),
      ],
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (ticket.status) {
      case TicketStatus.newTicket:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        statusText = 'New';
        break;
      case TicketStatus.assigned:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        statusText = 'Assigned';
        break;
      case TicketStatus.planned:
        backgroundColor = Colors.purple;
        textColor = Colors.white;
        statusText = 'Planned';
        break;
      case TicketStatus.pending:
        backgroundColor = Colors.amber;
        textColor = Colors.black;
        statusText = 'Pending';
        break;
      case TicketStatus.solved:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        statusText = 'Solved';
        break;
      case TicketStatus.closed:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        statusText = 'Closed';
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(ThemeData theme) {
    Color backgroundColor;
    Color textColor;
    String priorityText;
    IconData icon;

    switch (ticket.priority) {
      case TicketPriority.veryLow:
      case TicketPriority.low:
        backgroundColor = Colors.lightGreen;
        textColor = Colors.black;
        priorityText = 'Low';
        icon = Icons.arrow_downward;
        break;
      case TicketPriority.medium:
        backgroundColor = Colors.yellow;
        textColor = Colors.black;
        priorityText = 'Medium';
        icon = Icons.remove;
        break;
      case TicketPriority.high:
      case TicketPriority.veryHigh:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        priorityText = 'High';
        icon = Icons.arrow_upward;
        break;
      case TicketPriority.major:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        priorityText = 'Major';
        icon = Icons.warning;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        priorityText = 'Unknown';
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            priorityText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketId(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '#${ticket.id}',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      ticket.name,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Text(
      ticket.content!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      children: [
        if (ticket.date != null) ...[
          Icon(
            Icons.calendar_today,
            size: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
          Text(
            _formatDate(ticket.date!),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
        const Spacer(),
        if (ticket.hasLocation) ...[
          Icon(
            Icons.location_on,
            size: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
        ],
        if (ticket.usersIdAssign != null && ticket.usersIdAssign!.isNotEmpty) ...[
          Icon(
            Icons.person,
            size: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
          Text(
            '${ticket.usersIdAssign!.length}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Row(
      children: [
        if (ticket.hasLocation)
          TextButton.icon(
            icon: const Icon(Icons.map, size: 16),
            label: const Text('View on Map'),
            onPressed: () {
              // Handle map view
              _showOnMap();
            },
          ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.share, size: 16),
          onPressed: () {
            // Handle share
            _shareTicket();
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, size: 16),
          onPressed: () {
            // Handle favorite
            _toggleFavorite();
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOnMap() {
    if (ticket.latitude != null && ticket.longitude != null) {
      // In a real app, this would open a map view
      print('Showing ticket ${ticket.id} on map at ${ticket.latitude}, ${ticket.longitude}');
    }
  }

  void _shareTicket() {
    // In a real app, this would open a share dialog
    print('Sharing ticket ${ticket.id}');
  }

  void _toggleFavorite() {
    // In a real app, this would toggle favorite status
    print('Toggling favorite for ticket ${ticket.id}');
  }
}