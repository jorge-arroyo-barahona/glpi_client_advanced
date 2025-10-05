import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _preferences async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Authentication
  static Future<void> setAppToken(String token) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(AppConstants.keyAppToken, token);
    } catch (e) {
      throw CacheException('Failed to save app token: ${e.toString()}');
    }
  }

  static Future<String?> getAppToken() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(AppConstants.keyAppToken);
    } catch (e) {
      throw CacheException('Failed to get app token: ${e.toString()}');
    }
  }

  static Future<void> removeAppToken() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(AppConstants.keyAppToken);
    } catch (e) {
      throw CacheException('Failed to remove app token: ${e.toString()}');
    }
  }

  // Session
  static Future<void> setSessionToken(String token) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(AppConstants.keySessionToken, token);
    } catch (e) {
      throw CacheException('Failed to save session token: ${e.toString()}');
    }
  }

  static Future<String?> getSessionToken() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(AppConstants.keySessionToken);
    } catch (e) {
      throw CacheException('Failed to get session token: ${e.toString()}');
    }
  }

  static Future<void> removeSessionToken() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(AppConstants.keySessionToken);
    } catch (e) {
      throw CacheException('Failed to remove session token: ${e.toString()}');
    }
  }

  // User Profile
  static Future<void> setUserProfile(Map<String, dynamic> profile) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(AppConstants.keyUserProfile, jsonEncode(profile));
    } catch (e) {
      throw CacheException('Failed to save user profile: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final prefs = await _preferences;
      final profileJson = prefs.getString(AppConstants.keyUserProfile);
      return profileJson != null ? jsonDecode(profileJson) as Map<String, dynamic> : null;
    } catch (e) {
      throw CacheException('Failed to get user profile: ${e.toString()}');
    }
  }

  // User Preferences
  static Future<void> setUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(AppConstants.keyUserPreferences, jsonEncode(preferences));
    } catch (e) {
      throw CacheException('Failed to save user preferences: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      final prefs = await _preferences;
      final preferencesJson = prefs.getString(AppConstants.keyUserPreferences);
      return preferencesJson != null ? jsonDecode(preferencesJson) as Map<String, dynamic> : null;
    } catch (e) {
      throw CacheException('Failed to get user preferences: ${e.toString()}');
    }
  }

  // Last Sync Date
  static Future<void> setLastSyncDate(DateTime date) async {
    try {
      final prefs = await _preferences;
      await prefs.setInt(AppConstants.keyLastSync, date.millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException('Failed to save last sync date: ${e.toString()}');
    }
  }

  static Future<DateTime?> getLastSyncDate() async {
    try {
      final prefs = await _preferences;
      final timestamp = prefs.getInt(AppConstants.keyLastSync);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      throw CacheException('Failed to get last sync date: ${e.toString()}');
    }
  }

  // Geolocation
  static Future<void> setGeolocationEnabled(bool enabled) async {
    try {
      final prefs = await _preferences;
      await prefs.setBool(AppConstants.keyGeolocationEnabled, enabled);
    } catch (e) {
      throw CacheException('Failed to save geolocation setting: ${e.toString()}');
    }
  }

  static Future<bool> isGeolocationEnabled() async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(AppConstants.keyGeolocationEnabled) ?? false;
    } catch (e) {
      throw CacheException('Failed to get geolocation setting: ${e.toString()}');
    }
  }

  // AI Integration
  static Future<void> setAIEnabled(bool enabled) async {
    try {
      final prefs = await _preferences;
      await prefs.setBool(AppConstants.keyAIEnabled, enabled);
    } catch (e) {
      throw CacheException('Failed to save AI setting: ${e.toString()}');
    }
  }

  static Future<bool> isAIEnabled() async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(AppConstants.keyAIEnabled) ?? false;
    } catch (e) {
      throw CacheException('Failed to get AI setting: ${e.toString()}');
    }
  }

  // Theme
  static Future<void> setThemeMode(String themeMode) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(AppConstants.keyThemeMode, themeMode);
    } catch (e) {
      throw CacheException('Failed to save theme mode: ${e.toString()}');
    }
  }

  static Future<String?> getThemeMode() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(AppConstants.keyThemeMode);
    } catch (e) {
      throw CacheException('Failed to get theme mode: ${e.toString()}');
    }
  }

  // Language
  static Future<void> setLanguage(String language) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(AppConstants.keyLanguage, language);
    } catch (e) {
      throw CacheException('Failed to save language: ${e.toString()}');
    }
  }

  static Future<String?> getLanguage() async {
    try {
      final prefs = await _preferences;
      return prefs.getString(AppConstants.keyLanguage);
    } catch (e) {
      throw CacheException('Failed to get language: ${e.toString()}');
    }
  }

  // Notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await _preferences;
      await prefs.setBool(AppConstants.keyNotificationsEnabled, enabled);
    } catch (e) {
      throw CacheException('Failed to save notifications setting: ${e.toString()}');
    }
  }

  static Future<bool> isNotificationsEnabled() async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
    } catch (e) {
      throw CacheException('Failed to get notifications setting: ${e.toString()}');
    }
  }

  // Favorite Tickets
  static Future<void> addFavoriteTicket(int ticketId) async {
    try {
      final prefs = await _preferences;
      final favorites = await getFavoriteTickets();
      if (!favorites.contains(ticketId)) {
        favorites.add(ticketId);
        await prefs.setStringList(
          'favorite_tickets',
          favorites.map((id) => id.toString()).toList(),
        );
      }
    } catch (e) {
      throw CacheException('Failed to add favorite ticket: ${e.toString()}');
    }
  }

  static Future<void> removeFavoriteTicket(int ticketId) async {
    try {
      final prefs = await _preferences;
      final favorites = await getFavoriteTickets();
      favorites.remove(ticketId);
      await prefs.setStringList(
        'favorite_tickets',
        favorites.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      throw CacheException('Failed to remove favorite ticket: ${e.toString()}');
    }
  }

  static Future<List<int>> getFavoriteTickets() async {
    try {
      final prefs = await _preferences;
      final favoriteStrings = prefs.getStringList('favorite_tickets') ?? [];
      return favoriteStrings.map((id) => int.parse(id)).toList();
    } catch (e) {
      throw CacheException('Failed to get favorite tickets: ${e.toString()}');
    }
  }

  // Recent Tickets
  static Future<void> addRecentTicket(int ticketId) async {
    try {
      final prefs = await _preferences;
      final recent = await getRecentTickets();
      recent.remove(ticketId); // Remove if already exists
      recent.insert(0, ticketId); // Add to beginning
      
      // Keep only recent items
      if (recent.length > AppConstants.maxRecentItems) {
        recent.removeRange(AppConstants.maxRecentItems, recent.length);
      }
      
      await prefs.setStringList(
        'recent_tickets',
        recent.map((id) => id.toString()).toList(),
      );
    } catch (e) {
      throw CacheException('Failed to add recent ticket: ${e.toString()}');
    }
  }

  static Future<List<int>> getRecentTickets() async {
    try {
      final prefs = await _preferences;
      final recentStrings = prefs.getStringList('recent_tickets') ?? [];
      return recentStrings.map((id) => int.parse(id)).toList();
    } catch (e) {
      throw CacheException('Failed to get recent tickets: ${e.toString()}');
    }
  }

  // Cached Data
  static Future<void> setCachedData(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await _preferences;
      await prefs.setString('${AppConstants.keyCachedData}_$key', jsonEncode(data));
    } catch (e) {
      throw CacheException('Failed to cache data: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getCachedData(String key) async {
    try {
      final prefs = await _preferences;
      final dataJson = prefs.getString('${AppConstants.keyCachedData}_$key');
      return dataJson != null ? jsonDecode(dataJson) as Map<String, dynamic> : null;
    } catch (e) {
      throw CacheException('Failed to get cached data: ${e.toString()}');
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    try {
      final prefs = await _preferences;
      await prefs.clear();
    } catch (e) {
      throw CacheException('Failed to clear all data: ${e.toString()}');
    }
  }

  // Clear specific keys
  static Future<void> clearAuthentication() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(AppConstants.keyAppToken);
      await prefs.remove(AppConstants.keySessionToken);
      await prefs.remove(AppConstants.keyUserProfile);
    } catch (e) {
      throw CacheException('Failed to clear authentication data: ${e.toString()}');
    }
  }
}