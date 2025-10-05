import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/domain/entities/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, AppConstants.databaseName);

    return await openDatabase(
      dbPath,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tickets table
    await db.execute('''
      CREATE TABLE tickets (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        content TEXT,
        status INTEGER,
        priority INTEGER,
        urgency INTEGER,
        impact INTEGER,
        type INTEGER,
        users_id_recipient INTEGER,
        date TEXT,
        date_mod TEXT,
        entities_id INTEGER,
        itilcategories_id INTEGER,
        locations_id INTEGER,
        latitude REAL,
        longitude REAL,
        requesttypes_id INTEGER,
        tickets_id INTEGER,
        users_id_last_updater INTEGER,
        solvedate TEXT,
        closedate TEXT,
        slas_id INTEGER,
        olas_id INTEGER,
        internal_time_to_resolve TEXT,
        internal_time_to_own TEXT,
        waiting_duration TEXT,
        close_delay_stat TEXT,
        solve_delay_stat TEXT,
        takeintoaccount_delay_stat TEXT,
        actiontime TEXT,
        is_deleted INTEGER DEFAULT 0,
        locations_id_field TEXT,
        links TEXT,
        users_id_assign TEXT,
        users_id_requester TEXT,
        users_id_observer TEXT,
        groups_id_assign TEXT,
        groups_id_requester TEXT,
        groups_id_observer TEXT,
        cached_at INTEGER NOT NULL
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        realname TEXT,
        firstname TEXT,
        email TEXT,
        phone TEXT,
        mobile TEXT,
        locations_id INTEGER,
        usertitles_id INTEGER,
        usercategories_id INTEGER,
        is_active INTEGER DEFAULT 1,
        comment TEXT,
        language TEXT,
        date_format TEXT,
        number_format TEXT,
        names_format TEXT,
        csv_delimiter TEXT,
        use_flat_dropdowntree INTEGER DEFAULT 0,
        show_count_on_tabs INTEGER DEFAULT 0,
        refresh_tickets_list INTEGER DEFAULT 0,
        set_default_tech INTEGER DEFAULT 0,
        set_default_requester INTEGER DEFAULT 0,
        priority_as_icon INTEGER DEFAULT 0,
        task_state INTEGER DEFAULT 0,
        fold_menu INTEGER DEFAULT 0,
        fold_search INTEGER DEFAULT 0,
        savedsearches_pinned INTEGER DEFAULT 0,
        timezone TEXT,
        date_mod TEXT,
        last_login TEXT,
        date_creation TEXT,
        auths_id TEXT,
        authtype TEXT,
        user_dn TEXT,
        registration_number TEXT,
        picture TEXT,
        cached_at INTEGER NOT NULL
      )
    ''');

    // Create search history table
    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        user_id INTEGER,
        timestamp INTEGER NOT NULL,
        results_count INTEGER
      )
    ''');

    // Create user activity table for local awareness
    await db.execute('''
      CREATE TABLE user_activity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        action_type TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id INTEGER,
        metadata TEXT,
        timestamp INTEGER NOT NULL,
        location_lat REAL,
        location_lng REAL
      )
    ''');

    // Create indices for better performance
    await db.execute('CREATE INDEX idx_tickets_status ON tickets(status)');
    await db.execute('CREATE INDEX idx_tickets_priority ON tickets(priority)');
    await db.execute('CREATE INDEX idx_tickets_date ON tickets(date)');
    await db.execute('CREATE INDEX idx_tickets_users_id_recipient ON tickets(users_id_recipient)');
    await db.execute('CREATE INDEX idx_tickets_locations_id ON tickets(locations_id)');
    await db.execute('CREATE INDEX idx_tickets_cached_at ON tickets(cached_at)');
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_search_history_user_id ON search_history(user_id)');
    await db.execute('CREATE INDEX idx_search_history_timestamp ON search_history(timestamp)');
    await db.execute('CREATE INDEX idx_user_activity_user_id ON user_activity(user_id)');
    await db.execute('CREATE INDEX idx_user_activity_timestamp ON user_activity(timestamp)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Example: Add new column in version 2
      // await db.execute('ALTER TABLE tickets ADD COLUMN new_column TEXT');
    }
  }

  // Ticket operations
  Future<void> insertTicket(Ticket ticket) async {
    try {
      final db = await database;
      final ticketModel = TicketModel.fromEntity(ticket);
      await db.insert(
        'tickets',
        {
          ...ticketModel.toJson(),
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to insert ticket: ${e.toString()}');
    }
  }

  Future<void> insertTickets(List<Ticket> tickets) async {
    try {
      final db = await database;
      final batch = db.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final ticket in tickets) {
        final ticketModel = TicketModel.fromEntity(ticket);
        batch.insert(
          'tickets',
          {
            ...ticketModel.toJson(),
            'cached_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException('Failed to insert tickets: ${e.toString()}');
    }
  }

  Future<Ticket?> getTicket(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'tickets',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return TicketModel.fromJson(maps.first).toEntity();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get ticket: ${e.toString()}');
    }
  }

  Future<List<Ticket>> getAllTickets() async {
    try {
      final db = await database;
      final maps = await db.query(
        'tickets',
        orderBy: 'date DESC',
      );

      return maps.map((map) => TicketModel.fromJson(map).toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get all tickets: ${e.toString()}');
    }
  }

  Future<List<Ticket>> getTicketsByIds(List<int> ids) async {
    try {
      final db = await database;
      final maps = await db.query(
        'tickets',
        where: 'id IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids,
      );

      return maps.map((map) => TicketModel.fromJson(map).toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get tickets by IDs: ${e.toString()}');
    }
  }

  Future<List<Ticket>> getTicketsByStatus(int status) async {
    try {
      final db = await database;
      final maps = await db.query(
        'tickets',
        where: 'status = ? AND is_deleted = 0',
        whereArgs: [status],
        orderBy: 'date DESC',
      );

      return maps.map((map) => TicketModel.fromJson(map).toEntity()).toList();
    } catch (e) {
      throw CacheException('Failed to get tickets by status: ${e.toString()}');
    }
  }

  Future<List<Ticket>> getTicketsByLocation({
    double? latitude,
    double? longitude,
    double radius = 1000, // meters
  }) async {
    try {
      final db = await database;
      
      if (latitude != null && longitude != null) {
        // Calculate bounding box for efficient querying
        const double earthRadius = 6371000; // meters
        final double latDelta = radius / earthRadius * (180 / 3.14159);
        final double lngDelta = radius / (earthRadius * (3.14159 / 180) * (3.14159 / 180));
        
        final maps = await db.rawQuery('''
          SELECT * FROM tickets 
          WHERE latitude IS NOT NULL AND longitude IS NOT NULL
          AND latitude BETWEEN ? AND ?
          AND longitude BETWEEN ? AND ?
          AND is_deleted = 0
          ORDER BY date DESC
        ''', [
          latitude - latDelta,
          latitude + latDelta,
          longitude - lngDelta,
          longitude + lngDelta,
        ]);

        // Filter by exact radius
        final tickets = maps.map((map) => TicketModel.fromJson(map).toEntity()).toList();
        return tickets.where((ticket) {
          if (ticket.latitude == null || ticket.longitude == null) return false;
          
          final distance = _calculateDistance(
            latitude,
            longitude,
            ticket.latitude!,
            ticket.longitude!,
          );
          return distance <= radius;
        }).toList();
      } else {
        // Return all tickets with location
        final maps = await db.query(
          'tickets',
          where: 'latitude IS NOT NULL AND longitude IS NOT NULL AND is_deleted = 0',
          orderBy: 'date DESC',
        );
        return maps.map((map) => TicketModel.fromJson(map).toEntity()).toList();
      }
    } catch (e) {
      throw CacheException('Failed to get tickets by location: ${e.toString()}');
    }
  }

  Future<void> updateTicket(Ticket ticket) async {
    try {
      final db = await database;
      final ticketModel = TicketModel.fromEntity(ticket);
      await db.update(
        'tickets',
        {
          ...ticketModel.toJson(),
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [ticket.id],
      );
    } catch (e) {
      throw CacheException('Failed to update ticket: ${e.toString()}');
    }
  }

  Future<void> deleteTicket(int id) async {
    try {
      final db = await database;
      await db.delete(
        'tickets',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException('Failed to delete ticket: ${e.toString()}');
    }
  }

  Future<void> clearTickets() async {
    try {
      final db = await database;
      await db.delete('tickets');
    } catch (e) {
      throw CacheException('Failed to clear tickets: ${e.toString()}');
    }
  }

  // Statistics
  Future<Map<String, int>> getTicketStatistics() async {
    try {
      final db = await database;
      final counts = await db.rawQuery('''
        SELECT 
          SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as new_tickets,
          SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) as assigned,
          SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) as planned,
          SUM(CASE WHEN status = 4 THEN 1 ELSE 0 END) as pending,
          SUM(CASE WHEN status = 5 THEN 1 ELSE 0 END) as solved,
          SUM(CASE WHEN status = 6 THEN 1 ELSE 0 END) as closed,
          COUNT(*) as total
        FROM tickets 
        WHERE is_deleted = 0
      ''');

      return {
        'new': counts.first['new_tickets'] as int? ?? 0,
        'assigned': counts.first['assigned'] as int? ?? 0,
        'planned': counts.first['planned'] as int? ?? 0,
        'pending': counts.first['pending'] as int? ?? 0,
        'solved': counts.first['solved'] as int? ?? 0,
        'closed': counts.first['closed'] as int? ?? 0,
        'total': counts.first['total'] as int? ?? 0,
      };
    } catch (e) {
      throw CacheException('Failed to get ticket statistics: ${e.toString()}');
    }
  }

  // User operations
  Future<void> insertUser(User user) async {
    try {
      final db = await database;
      final userModel = UserModel.fromEntity(user);
      await db.insert(
        'users',
        {
          ...userModel.toJson(),
          'cached_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to insert user: ${e.toString()}');
    }
  }

  Future<User?> getUser(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return UserModel.fromJson(maps.first).toEntity();
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user: ${e.toString()}');
    }
  }

  // Search history
  Future<void> insertSearchHistory({
    required String query,
    required String entityType,
    int? userId,
    int? resultsCount,
  }) async {
    try {
      final db = await database;
      await db.insert('search_history', {
        'query': query,
        'entity_type': entityType,
        'user_id': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'results_count': resultsCount,
      });

      // Keep only recent searches
      await db.delete(
        'search_history',
        where: 'id NOT IN (SELECT id FROM search_history ORDER BY timestamp DESC LIMIT ?)',
        whereArgs: [AppConstants.maxSearchHistory],
      );
    } catch (e) {
      throw CacheException('Failed to insert search history: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getSearchHistory({
    String? entityType,
    int? userId,
    int limit = 20,
  }) async {
    try {
      final db = await database;
      String where = '1=1';
      List<dynamic> whereArgs = [];

      if (entityType != null) {
        where += ' AND entity_type = ?';
        whereArgs.add(entityType);
      }

      if (userId != null) {
        where += ' AND user_id = ?';
        whereArgs.add(userId);
      }

      return await db.query(
        'search_history',
        where: where,
        whereArgs: whereArgs,
        orderBy: 'timestamp DESC',
        limit: limit,
      );
    } catch (e) {
      throw CacheException('Failed to get search history: ${e.toString()}');
    }
  }

  // User activity for local awareness
  Future<void> insertUserActivity({
    required int userId,
    required String actionType,
    required String entityType,
    int? entityId,
    Map<String, dynamic>? metadata,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final db = await database;
      await db.insert('user_activity', {
        'user_id': userId,
        'action_type': actionType,
        'entity_type': entityType,
        'entity_id': entityId,
        'metadata': metadata != null ? jsonEncode(metadata) : null,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'location_lat': latitude,
        'location_lng': longitude,
      });

      // Keep only recent activities
      await db.delete(
        'user_activity',
        where: 'id NOT IN (SELECT id FROM user_activity ORDER BY timestamp DESC LIMIT ?)',
        whereArgs: [1000], // Keep last 1000 activities
      );
    } catch (e) {
      throw CacheException('Failed to insert user activity: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserActivity({
    int? userId,
    String? actionType,
    String? entityType,
    int limit = 50,
  }) async {
    try {
      final db = await database;
      String where = '1=1';
      List<dynamic> whereArgs = [];

      if (userId != null) {
        where += ' AND user_id = ?';
        whereArgs.add(userId);
      }

      if (actionType != null) {
        where += ' AND action_type = ?';
        whereArgs.add(actionType);
      }

      if (entityType != null) {
        where += ' AND entity_type = ?';
        whereArgs.add(entityType);
      }

      return await db.query(
        'user_activity',
        where: where,
        whereArgs: whereArgs,
        orderBy: 'timestamp DESC',
        limit: limit,
      );
    } catch (e) {
      throw CacheException('Failed to get user activity: ${e.toString()}');
    }
  }

  // Utility methods
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.delete('tickets');
      await db.delete('users');
      await db.delete('search_history');
      await db.delete('user_activity');
    } catch (e) {
      throw CacheException('Failed to clear all data: ${e.toString()}');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Private helper methods
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371000; // meters
    final double dLat = (lat2 - lat1) * (3.14159 / 180);
    final double dLng = (lng2 - lng1) * (3.14159 / 180);
    final double a = (3.14159 / 180) * lat1;
    final double c = (3.14159 / 180) * lat2;
    final double x = dLng * cos((a + c) / 2);
    final double y = dLat;
    return sqrt(x * x + y * y) * earthRadius;
  }

  double sqrt(double x) {
    // Simple square root implementation
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}