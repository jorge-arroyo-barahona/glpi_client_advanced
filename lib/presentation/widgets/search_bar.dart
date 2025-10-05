import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';

class SearchBar extends ConsumerStatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final VoidCallback? onClear;
  final bool showFilters;
  final List<Widget>? filterActions;
  final Duration debounceDuration;

  const SearchBar({
    super.key,
    this.hintText = 'Search...',
    required this.onSearch,
    this.onClear,
    this.showFilters = false,
    this.filterActions,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearch(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debounceTimer?.cancel();
    widget.onSearch('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius * 2),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _isFocused
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: AppConstants.defaultPadding),
              Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(width: AppConstants.defaultPadding / 2),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onTextChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppConstants.defaultPadding,
                    ),
                    isDense: true,
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                  tooltip: 'Clear',
                ),
              if (widget.showFilters && widget.filterActions != null)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  onSelected: (value) {
                    // Handle filter selection
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'status',
                      child: Text('Filter by Status'),
                    ),
                    const PopupMenuItem(
                      value: 'priority',
                      child: Text('Filter by Priority'),
                    ),
                    const PopupMenuItem(
                      value: 'date',
                      child: Text('Filter by Date'),
                    ),
                    const PopupMenuItem(
                      value: 'category',
                      child: Text('Filter by Category'),
                    ),
                  ],
                ),
              const SizedBox(width: AppConstants.defaultPadding / 2),
            ],
          ),
          if (widget.showFilters && _isFocused)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          if (widget.showFilters && _isFocused && widget.filterActions != null)
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.filterActions!,
              ),
            ),
        ],
      ),
    );
  }
}

class SearchFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const SearchFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: theme.colorScheme.surfaceVariant,
      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class SearchHistory extends ConsumerWidget {
  final List<String> queries;
  final ValueChanged<String> onQuerySelected;
  final VoidCallback? onClear;

  const SearchHistory({
    super.key,
    required this.queries,
    required this.onQuerySelected,
    this.onClear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (queries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Text(
                  'Recent Searches',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onClear != null)
                  TextButton(
                    onPressed: onClear,
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: queries.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final query = queries[index];
              return ListTile(
                leading: const Icon(Icons.history, size: 20),
                title: Text(query),
                trailing: const Icon(Icons.north_west, size: 16),
                onTap: () => onQuerySelected(query),
                dense: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SearchSuggestions extends ConsumerWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionSelected;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.search, size: 20),
            title: Text(suggestion),
            onTap: () => onSuggestionSelected(suggestion),
            dense: true,
          );
        },
      ),
    );
  }
}
