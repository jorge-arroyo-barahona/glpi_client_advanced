import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  
  factory LocationService() => _instance;
  
  LocationService._internal();

  // Stream controllers
  final StreamController<Position> _positionController = StreamController<Position>.broadcast();
  final StreamController<bool> _serviceStatusController = StreamController<bool>.broadcast();
  
  // Public streams
  Stream<Position> get positionStream => _positionController.stream;
  Stream<bool> get serviceStatusStream => _serviceStatusController.stream;
  
  Position? _lastPosition;
  bool _isTracking = false;
  StreamSubscription<Position>? _positionSubscription;

  // Initialize location service
  Future<bool> initialize() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('Location services are disabled');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException('Location permissions are permanently denied');
      }

      return true;
    } catch (e) {
      throw LocationException('Failed to initialize location service: ${e.toString()}');
    }
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: AppConstants.locationTimeout,
      );
      
      _lastPosition = position;
      _positionController.add(position);
      
      return position;
    } catch (e) {
      throw LocationException('Failed to get current position: ${e.toString()}');
    }
  }

  // Get last known position
  Future<Position?> getLastKnownPosition() async {
    try {
      if (_lastPosition != null) {
        return _lastPosition;
      }
      
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      throw LocationException('Failed to get last known position: ${e.toString()}');
    }
  }

  // Start continuous position tracking
  Future<void> startTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // meters
  }) async {
    if (_isTracking) return;

    try {
      await initialize();
      
      final locationSettings = LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        timeLimit: AppConstants.locationTimeout,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _lastPosition = position;
          _positionController.add(position);
        },
        onError: (error) {
          throw LocationException('Position stream error: ${error.toString()}');
        },
      );

      _isTracking = true;
    } catch (e) {
      throw LocationException('Failed to start tracking: ${e.toString()}');
    }
  }

  // Stop position tracking
  Future<void> stopTracking() async {
    if (!_isTracking) return;

    try {
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      _isTracking = false;
    } catch (e) {
      throw LocationException('Failed to stop tracking: ${e.toString()}');
    }
  }

  // Check if tracking is active
  bool get isTracking => _isTracking;

  // Get address from coordinates
  Future<Placemark> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isEmpty) {
        throw LocationException('No address found for coordinates');
      }
      
      return placemarks.first;
    } catch (e) {
      throw LocationException('Failed to get address from coordinates: ${e.toString()}');
    }
  }

  // Get coordinates from address
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      throw LocationException('Failed to get coordinates from address: ${e.toString()}');
    }
  }

  // Calculate distance between two points
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Calculate bearing between two points
  double calculateBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if a point is within a radius
  bool isWithinRadius({
    required double centerLatitude,
    required double centerLongitude,
    required double pointLatitude,
    required double pointLongitude,
    required double radius, // in meters
  }) {
    final distance = calculateDistance(
      startLatitude: centerLatitude,
      startLongitude: centerLongitude,
      endLatitude: pointLatitude,
      endLongitude: pointLongitude,
    );
    
    return distance <= radius;
  }

  // Get location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // Open app settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  // Get location accuracy status
  Future<LocationAccuracyStatus> getLocationAccuracy() async {
    return await Geolocator.getLocationAccuracy();
  }

  // Request temporary full accuracy (iOS only)
  Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) async {
    return await Geolocator.requestTemporaryFullAccuracy(
      purposeKey: purposeKey,
    );
  }

  // Dispose resources
  void dispose() {
    _positionSubscription?.cancel();
    _positionController.close();
    _serviceStatusController.close();
  }

  // Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    final latDirection = latitude >= 0 ? 'N' : 'S';
    final lngDirection = longitude >= 0 ? 'E' : 'W';
    
    final latDegrees = latitude.abs().floor();
    final latMinutes = ((latitude.abs() - latDegrees) * 60).floor();
    final latSeconds = ((latitude.abs() - latDegrees - latMinutes / 60) * 3600);
    
    final lngDegrees = longitude.abs().floor();
    final lngMinutes = ((longitude.abs() - lngDegrees) * 60).floor();
    final lngSeconds = ((longitude.abs() - lngDegrees - lngMinutes / 60) * 3600);
    
    return '${latDegrees}°${latMinutes}\'${latSeconds.toStringAsFixed(2)}"$latDirection, '
           '${lngDegrees}°${lngMinutes}\'${lngSeconds.toStringAsFixed(2)}"$lngDirection';
  }

  // Format distance for display
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  // Format address for display
  static String formatAddress(Placemark placemark) {
    final parts = [
      placemark.name,
      placemark.street,
      placemark.locality,
      placemark.administrativeArea,
      placemark.country,
    ].where((part) => part != null && part.isNotEmpty).toList();
    
    return parts.join(', ');
  }
}