import 'dart:async';
import 'dart:convert';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';
import 'package:glpi_client_advanced/data/datasources/local/database_helper.dart';
import 'package:glpi_client_advanced/data/datasources/local/shared_preferences_helper.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';

class LocalAwarenessService {
  static final LocalAwarenessService _instance =
      LocalAwarenessService._internal();

  factory LocalAwarenessService() => _instance;

  LocalAwarenessService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();

  // Stream controllers for real-time updates
  final StreamController<Map<String, dynamic>> _insightsController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<List<Map<String, dynamic>>>
      _recommendationsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  // Public streams
  Stream<Map<String, dynamic>> get insightsStream => _insightsController.stream;
  Stream<List<Map<String, dynamic>>> get recommendationsStream =>
      _recommendationsController.stream;

  // User pattern analysis
  Map<String, dynamic> _userPatterns = {};
  Timer? _analysisTimer;

  // Initialize local awareness service
  Future<void> initialize() async {
    try {
      // Load existing patterns from storage
      await _loadUserPatterns();

      // Start periodic analysis
      _startPeriodicAnalysis();

      // Generate initial insights
      await _generateInsights();
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to initialize local awareness: ${e.toString()}');
    }
  }

  // Record user activity
  Future<void> recordActivity({
    required int userId,
    required String actionType,
    required String entityType,
    int? entityId,
    Map<String, dynamic>? metadata,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await _databaseHelper.insertUserActivity(
        userId: userId,
        actionType: actionType,
        entityType: entityType,
        entityId: entityId,
        metadata: metadata,
        latitude: latitude,
        longitude: longitude,
      );

      // Update patterns in real-time
      await _updatePatterns();
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to record activity: ${e.toString()}');
    }
  }

  // Record ticket view
  Future<void> recordTicketView(int userId, int ticketId) async {
    await recordActivity(
      userId: userId,
      actionType: 'view',
      entityType: 'ticket',
      entityId: ticketId,
    );
  }

  // Record ticket creation
  Future<void> recordTicketCreation(
      int userId, int ticketId, Map<String, dynamic> metadata) async {
    await recordActivity(
      userId: userId,
      actionType: 'create',
      entityType: 'ticket',
      entityId: ticketId,
      metadata: metadata,
    );
  }

  // Record ticket update
  Future<void> recordTicketUpdate(
      int userId, int ticketId, Map<String, dynamic> changes) async {
    await recordActivity(
      userId: userId,
      actionType: 'update',
      entityType: 'ticket',
      entityId: ticketId,
      metadata: changes,
    );
  }

  // Record search query
  Future<void> recordSearch(
      int userId, String query, String entityType, int? resultsCount) async {
    await _databaseHelper.insertSearchHistory(
      query: query,
      entityType: entityType,
      userId: userId,
      resultsCount: resultsCount,
    );

    await recordActivity(
      userId: userId,
      actionType: 'search',
      entityType: entityType,
      metadata: {'query': query, 'results_count': resultsCount},
    );
  }

  // Get user activity history
  Future<List<Map<String, dynamic>>> getUserActivity({
    int? userId,
    String? actionType,
    String? entityType,
    int limit = 50,
  }) async {
    try {
      return await _databaseHelper.getUserActivity(
        userId: userId,
        actionType: actionType,
        entityType: entityType,
        limit: limit,
      );
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to get user activity: ${e.toString()}');
    }
  }

  // Get search history
  Future<List<Map<String, dynamic>>> getSearchHistory({
    String? entityType,
    int? userId,
    int limit = 20,
  }) async {
    try {
      return await _databaseHelper.getSearchHistory(
        entityType: entityType,
        userId: userId,
        limit: limit,
      );
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to get search history: ${e.toString()}');
    }
  }

  // Analyze user patterns
  Future<Map<String, dynamic>> analyzeUserPatterns({int? userId}) async {
    try {
      final activity = await getUserActivity(userId: userId, limit: 1000);
      final searchHistory = await getSearchHistory(userId: userId, limit: 100);

      return _analyzePatterns(activity, searchHistory);
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to analyze user patterns: ${e.toString()}');
    }
  }

  // Get personalized recommendations
  Future<List<Map<String, dynamic>>> getRecommendations({int? userId}) async {
    try {
      final patterns = await analyzeUserPatterns(userId: userId);
      return _generateRecommendations(patterns);
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to get recommendations: ${e.toString()}');
    }
  }

  // Predict next actions
  Future<List<String>> predictNextActions({int? userId}) async {
    try {
      final patterns = await analyzeUserPatterns(userId: userId);
      return _predictActions(patterns);
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to predict next actions: ${e.toString()}');
    }
  }

  // Suggest frequently used actions
  Future<List<Map<String, dynamic>>> suggestFrequentActions(
      {int? userId}) async {
    try {
      final activity = await getUserActivity(userId: userId, limit: 100);
      return _getFrequentActions(activity);
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to suggest frequent actions: ${e.toString()}');
    }
  }

  // Get workflow recommendations
  Future<List<Map<String, dynamic>>> getWorkflowRecommendations(
      {int? userId}) async {
    try {
      final activity = await getUserActivity(userId: userId, limit: 200);
      return _analyzeWorkflows(activity);
    } catch (e) {
      throw LocalAwarenessException(
          'Failed to get workflow recommendations: ${e.toString()}');
    }
  }

  // Private methods
  Future<void> _loadUserPatterns() async {
    try {
      final cachedPatterns =
          await _sharedPreferencesHelper.getCachedData('user_patterns');
      if (cachedPatterns != null) {
        _userPatterns = cachedPatterns;
      }
    } catch (e) {
      // Start with empty patterns if loading fails
      _userPatterns = {};
    }
  }

  Future<void> _saveUserPatterns() async {
    try {
      await _sharedPreferencesHelper.setCachedData(
          'user_patterns', _userPatterns);
    } catch (e) {
      // Silently fail if saving fails
    }
  }

  void _startPeriodicAnalysis() {
    _analysisTimer = Timer.periodic(const Duration(minutes: 30), (timer) async {
      await _updatePatterns();
      await _generateInsights();
    });
  }

  Future<void> _updatePatterns() async {
    try {
      final newPatterns = await analyzeUserPatterns();
      if (_patternsChanged(_userPatterns, newPatterns)) {
        _userPatterns = newPatterns;
        await _saveUserPatterns();
      }
    } catch (e) {
      // Silently fail if pattern update fails
    }
  }

  bool _patternsChanged(
      Map<String, dynamic> oldPatterns, Map<String, dynamic> newPatterns) {
    // Simple comparison - in production, you might want more sophisticated change detection
    return oldPatterns.hashCode != newPatterns.hashCode;
  }

  Future<void> _generateInsights() async {
    try {
      final insights = await _calculateInsights();
      _insightsController.add(insights);

      final recommendations = await getRecommendations();
      _recommendationsController.add(recommendations);
    } catch (e) {
      // Silently fail if insight generation fails
    }
  }

  Future<Map<String, dynamic>> _calculateInsights() async {
    final activity = await getUserActivity(limit: 500);
    final searchHistory = await getSearchHistory(limit: 100);

    return {
      'total_activities': activity.length,
      'most_active_hour': _getMostActiveHour(activity),
      'most_active_day': _getMostActiveDay(activity),
      'preferred_ticket_status': _getPreferredTicketStatus(activity),
      'search_patterns': _analyzeSearchPatterns(searchHistory),
      'workflow_efficiency': _calculateWorkflowEfficiency(activity),
      'geographic_patterns': _analyzeGeographicPatterns(activity),
    };
  }

  Map<String, dynamic> _analyzePatterns(
    List<Map<String, dynamic>> activity,
    List<Map<String, dynamic>> searchHistory,
  ) {
    return {
      'activity_frequency': _calculateActivityFrequency(activity),
      'peak_activity_times': _getPeakActivityTimes(activity),
      'common_actions': _getCommonActions(activity),
      'search_trends': _analyzeSearchTrends(searchHistory),
      'ticket_lifecycle_patterns': _analyzeTicketLifecycle(activity),
      'preferred_workflow': _identifyPreferredWorkflow(activity),
    };
  }

  List<Map<String, dynamic>> _generateRecommendations(
      Map<String, dynamic> patterns) {
    final recommendations = <Map<String, dynamic>>[];

    // Workflow optimization recommendations
    if (patterns['workflow_efficiency'] != null &&
        patterns['workflow_efficiency'] < 0.7) {
      recommendations.add({
        'type': 'workflow_optimization',
        'title': 'Optimize Your Workflow',
        'description': 'Consider batching similar tasks to improve efficiency',
        'priority': 'medium',
        'actions': ['Review recent ticket patterns', 'Group similar tasks'],
      });
    }

    // Time management recommendations
    if (patterns['peak_activity_times'] != null) {
      recommendations.add({
        'type': 'time_management',
        'title': 'Optimize Your Schedule',
        'description': 'Schedule complex tasks during your peak hours',
        'priority': 'low',
        'actions': ['Identify peak productivity hours', 'Schedule accordingly'],
      });
    }

    // Skill development recommendations
    if (patterns['common_actions'] != null) {
      final commonActions =
          patterns['common_actions'] as List<Map<String, dynamic>>;
      if (commonActions.any((action) => action['action'] == 'search')) {
        recommendations.add({
          'type': 'skill_development',
          'title': 'Improve Search Efficiency',
          'description': 'Use advanced search filters to find tickets faster',
          'priority': 'low',
          'actions': ['Learn advanced search syntax', 'Use saved searches'],
        });
      }
    }

    return recommendations;
  }

  List<String> _predictActions(Map<String, dynamic> patterns) {
    final predictions = <String>[];

    // Based on historical patterns
    if (patterns['preferred_workflow'] != null) {
      final workflow = patterns['preferred_workflow'] as String;
      switch (workflow) {
        case 'ticket_creation_focused':
          predictions.add('Create new ticket');
          predictions.add('Review recent tickets');
          break;
        case 'ticket_resolution_focused':
          predictions.add('Update ticket status');
          predictions.add('Add ticket comment');
          break;
        case 'search_focused':
          predictions.add('Search for tickets');
          predictions.add('View search history');
          break;
      }
    }

    // Based on time patterns
    if (patterns['peak_activity_times'] != null) {
      predictions.add('Review daily statistics');
      predictions.add('Check pending tickets');
    }

    return predictions.take(3).toList();
  }

  List<Map<String, dynamic>> _getFrequentActions(
      List<Map<String, dynamic>> activity) {
    final actionCounts = <String, int>{};

    for (final action in activity) {
      final actionType = action['action_type'] as String;
      actionCounts[actionType] = (actionCounts[actionType] ?? 0) + 1;
    }

    final sortedActions = actionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedActions
        .take(5)
        .map((entry) => {
              'action': entry.key,
              'count': entry.value,
              'frequency': entry.value / activity.length,
            })
        .toList();
  }

  List<Map<String, dynamic>> _analyzeWorkflows(
      List<Map<String, dynamic>> activity) {
    // Group activities by ticket to analyze workflows
    final ticketWorkflows = <int, List<Map<String, dynamic>>>{};

    for (final action in activity) {
      if (action['entity_type'] == 'ticket' && action['entity_id'] != null) {
        final ticketId = action['entity_id'] as int;
        ticketWorkflows.putIfAbsent(ticketId, () => []).add(action);
      }
    }

    // Analyze common workflow patterns
    final workflowPatterns = <String, int>{};

    for (final workflow in ticketWorkflows.values) {
      // Sort by timestamp
      workflow.sort(
          (a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));

      // Create workflow pattern string
      final pattern =
          workflow.map((action) => action['action_type']).join(' -> ');
      workflowPatterns[pattern] = (workflowPatterns[pattern] ?? 0) + 1;
    }

    return workflowPatterns.entries
        .take(5)
        .map((entry) => {
              'workflow': entry.key,
              'count': entry.value,
            })
        .toList();
  }

  // Simple analysis methods (implementations would be more sophisticated in production)
  String _getMostActiveHour(List<Map<String, dynamic>> activity) {
    final hourCounts = List<int>.filled(24, 0);

    for (final action in activity) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(action['timestamp'] as int);
      hourCounts[timestamp.hour]++;
    }

    final maxHour =
        hourCounts.indexOf(hourCounts.reduce((a, b) => a > b ? a : b));
    return '$maxHour:00';
  }

  String _getMostActiveDay(List<Map<String, dynamic>> activity) {
    final dayCounts = List<int>.filled(7, 0);

    for (final action in activity) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(action['timestamp'] as int);
      dayCounts[timestamp.weekday - 1]++;
    }

    final maxDay = dayCounts.indexOf(dayCounts.reduce((a, b) => a > b ? a : b));
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[maxDay];
  }

  String _getPreferredTicketStatus(List<Map<String, dynamic>> activity) {
    final statusCounts = <String, int>{};

    for (final action in activity.where((a) => a['entity_type'] == 'ticket')) {
      final metadata = action['metadata'] != null
          ? jsonDecode(action['metadata'] as String)
          : {};
      final status = metadata['status']?.toString() ?? 'unknown';
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    return statusCounts.entries.isNotEmpty
        ? statusCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'unknown';
  }

  Map<String, dynamic> _analyzeSearchPatterns(
      List<Map<String, dynamic>> searchHistory) {
    return {
      'total_searches': searchHistory.length,
      'most_common_entity': _getMostCommonEntity(searchHistory),
      'average_query_length': _calculateAverageQueryLength(searchHistory),
    };
  }

  String _getMostCommonEntity(List<Map<String, dynamic>> searchHistory) {
    final entityCounts = <String, int>{};

    for (final search in searchHistory) {
      final entity = search['entity_type'] as String;
      entityCounts[entity] = (entityCounts[entity] ?? 0) + 1;
    }

    return entityCounts.entries.isNotEmpty
        ? entityCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'ticket';
  }

  double _calculateAverageQueryLength(
      List<Map<String, dynamic>> searchHistory) {
    if (searchHistory.isEmpty) return 0.0;

    final totalLength = searchHistory.fold<int>(
      0,
      (sum, search) => sum + (search['query'] as String).length,
    );

    return totalLength / searchHistory.length;
  }

  double _calculateWorkflowEfficiency(List<Map<String, dynamic>> activity) {
    // Simple efficiency calculation based on time between actions
    if (activity.length < 2) return 1.0;

    var totalTime = 0;
    var actionCount = 0;

    for (var i = 1; i < activity.length; i++) {
      final prevTime = activity[i - 1]['timestamp'] as int;
      final currTime = activity[i]['timestamp'] as int;
      final timeDiff = currTime - prevTime;

      // Only consider actions within reasonable time (5 minutes to 2 hours)
      if (timeDiff > 300000 && timeDiff < 7200000) {
        totalTime += timeDiff;
        actionCount++;
      }
    }

    return actionCount > 0
        ? (actionCount * 300000 / totalTime).clamp(0.0, 1.0)
        : 1.0;
  }

  Map<String, dynamic> _analyzeGeographicPatterns(
      List<Map<String, dynamic>> activity) {
    final locations = activity
        .where((a) => a['location_lat'] != null && a['location_lng'] != null);

    return {
      'total_location_activities': locations.length,
      'most_common_location': _getMostCommonLocation(locations.toList()),
      'location_variance': _calculateLocationVariance(locations.toList()),
    };
  }

  String _getMostCommonLocation(List<Map<String, dynamic>> locations) {
    // Simplified - in production, you'd cluster locations
    return locations.isNotEmpty ? 'Primary Location' : 'None';
  }

  double _calculateLocationVariance(List<Map<String, dynamic>> locations) {
    if (locations.isEmpty) return 0.0;

    // Simplified variance calculation
    return locations.length.toDouble();
  }

  Map<String, dynamic> _calculateActivityFrequency(
      List<Map<String, dynamic>> activity) {
    final now = DateTime.now();
    final last24h = activity.where((a) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(a['timestamp'] as int);
      return now.difference(timestamp).inHours <= 24;
    }).length;

    final last7d = activity.where((a) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(a['timestamp'] as int);
      return now.difference(timestamp).inDays <= 7;
    }).length;

    final last30d = activity.where((a) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(a['timestamp'] as int);
      return now.difference(timestamp).inDays <= 30;
    }).length;

    return {
      'last_24h': last24h,
      'last_7d': last7d,
      'last_30d': last30d,
    };
  }

  List<String> _getPeakActivityTimes(List<Map<String, dynamic>> activity) {
    final hourCounts = List<int>.filled(24, 0);

    for (final action in activity) {
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(action['timestamp'] as int);
      hourCounts[timestamp.hour]++;
    }

    // Get top 3 hours
    final sortedHours = List.generate(24, (i) => i)
      ..sort((a, b) => hourCounts[b].compareTo(hourCounts[a]));

    return sortedHours.take(3).map((hour) => '$hour:00').toList();
  }

  List<String> _getCommonActions(List<Map<String, dynamic>> activity) {
    final actionCounts = <String, int>{};

    for (final action in activity) {
      final actionType = action['action_type'] as String;
      actionCounts[actionType] = (actionCounts[actionType] ?? 0) + 1;
    }

    return actionCounts.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .take(5)
        .map((e) => e.key)
        .toList();
  }

  List<String> _analyzeSearchTrends(List<Map<String, dynamic>> searchHistory) {
    // Extract common search terms
    final terms = <String, int>{};

    for (final search in searchHistory) {
      final query = search['query'] as String;
      final words = query.toLowerCase().split(' ');
      for (final word in words) {
        if (word.length > 3) {
          terms[word] = (terms[word] ?? 0) + 1;
        }
      }
    }

    return terms.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .take(10)
        .map((e) => e.key)
        .toList();
  }

  List<String> _analyzeTicketLifecycle(List<Map<String, dynamic>> activity) {
    // Analyze common ticket workflows
    final lifecyclePatterns = <String, int>{};

    for (final action in activity.where((a) => a['entity_type'] == 'ticket')) {
      final actionType = action['action_type'] as String;
      lifecyclePatterns[actionType] = (lifecyclePatterns[actionType] ?? 0) + 1;
    }

    return lifecyclePatterns.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .take(5)
        .map((e) => e.key)
        .toList();
  }

  String _identifyPreferredWorkflow(List<Map<String, dynamic>> activity) {
    final actionCounts = <String, int>{};

    for (final action in activity) {
      final actionType = action['action_type'] as String;
      actionCounts[actionType] = (actionCounts[actionType] ?? 0) + 1;
    }

    final mostCommon = actionCounts.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        .firstOrNull;

    if (mostCommon != null) {
      switch (mostCommon.key) {
        case 'create':
          return 'ticket_creation_focused';
        case 'update':
        case 'resolve':
          return 'ticket_resolution_focused';
        case 'search':
          return 'search_focused';
        default:
          return 'balanced';
      }
    }

    return 'balanced';
  }

  // Dispose resources
  void dispose() {
    _analysisTimer?.cancel();
    _insightsController.close();
    _recommendationsController.close();
  }
}

// Extension for sorting
extension ListExtensions<T> on List<T> {
  List<T> sorted([int Function(T a, T b)? compare]) {
    final list = List<T>.from(this);
    list.sort(compare);
    return list;
  }
}
