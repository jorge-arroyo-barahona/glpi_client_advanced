import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/services/location_service.dart';

class LocationWidget extends ConsumerStatefulWidget {
  final Function(double, double)? onLocationSelected;
  final bool showMap;
  final bool showAddress;
  final String? initialAddress;

  const LocationWidget({
    super.key,
    this.onLocationSelected,
    this.showMap = true,
    this.showAddress = true,
    this.initialAddress,
  });

  @override
  ConsumerState<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends ConsumerState<LocationWidget> {
  final LocationService _locationService = LocationService();
  final TextEditingController _addressController = TextEditingController();

  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  bool _isServiceEnabled = false;
  LocationPermission? _permission;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialAddress ?? '';
    _initializeLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _locationService.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if location service is enabled
      _isServiceEnabled = await _locationService.isLocationServiceEnabled();

      // Check permission
      _permission = await _locationService.checkPermission();

      if (_permission == LocationPermission.denied) {
        _permission = await _locationService.requestPermission();
      }

      if (_isServiceEnabled && _permission == LocationPermission.whileInUse ||
          _permission == LocationPermission.always) {
        // Get current position
        _currentPosition = await _locationService.getCurrentPosition();

        if (widget.showAddress && _currentPosition != null) {
          await _getAddressFromCoordinates();
        }
      }
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (!_isServiceEnabled) {
        final enabled = await _locationService.openLocationSettings();
        if (!enabled) {
          throw Exception('Location services are disabled');
        }
      }

      if (_permission == LocationPermission.denied ||
          _permission == LocationPermission.deniedForever) {
        _permission = await _locationService.requestPermission();
        if (_permission == LocationPermission.denied ||
            _permission == LocationPermission.deniedForever) {
          throw Exception('Location permission denied');
        }
      }

      _currentPosition = await _locationService.getCurrentPosition();

      if (widget.showAddress && _currentPosition != null) {
        await _getAddressFromCoordinates();
      }

      if (_currentPosition != null && widget.onLocationSelected != null) {
        widget.onLocationSelected!(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } catch (e) {
      _showError('Failed to get current location: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getAddressFromCoordinates() async {
    if (_currentPosition == null) return;

    try {
      final placemark = await _locationService.getAddressFromCoordinates(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );

      setState(() {
        _currentAddress = LocationService.formatAddress(placemark);
        _addressController.text = _currentAddress!;
      });
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  Future<void> _searchAddress() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final locations =
          await _locationService.getCoordinatesFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;
        setState(() {
          _currentPosition = Position(
            latitude: location.latitude,
            longitude: location.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
          );
          _currentAddress = address;
        });

        if (widget.onLocationSelected != null) {
          widget.onLocationSelected!(location.latitude, location.longitude);
        }
      } else {
        _showError('Address not found');
      }
    } catch (e) {
      _showError('Failed to search address: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Current Location Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: const Text('Use Current Location'),
                  ),
                ),
                if (_currentPosition != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      // Show on map
                      _showMapView();
                    },
                    tooltip: 'View on Map',
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Coordinates Display
            if (_currentPosition != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coordinates',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LocationService.formatCoordinates(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],

            // Address Search
            if (widget.showAddress) ...[
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter address or place name',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.defaultRadius),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _isLoading ? null : _searchAddress,
                  ),
                ),
                onSubmitted: (_) => _searchAddress(),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],

            // Location Actions
            if (_currentPosition != null) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _shareLocation();
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share Location'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _copyCoordinates();
                      },
                      icon: const Icon(Icons.content_copy),
                      label: const Text('Copy Coordinates'),
                    ),
                  ),
                ],
              ),
            ],

            // Status Messages
            if (!_isServiceEnabled) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_off,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location services are disabled. Please enable them in settings.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_permission == LocationPermission.denied ||
                _permission == LocationPermission.deniedForever) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Location permission is required. Please grant permission in app settings.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showMapView() {
    if (_currentPosition == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Location'),
          content: SizedBox(
            width: 300,
            height: 200,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}\n'
                            'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _currentAddress ?? 'Address not available',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _copyCoordinates();
                Navigator.pop(context);
              },
              child: const Text('Copy Coordinates'),
            ),
          ],
        );
      },
    );
  }

  void _shareLocation() {
    if (_currentPosition == null) return;

    final text = 'My location:\n'
        'Coordinates: ${LocationService.formatCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    )}\n'
        'Address: ${_currentAddress ?? 'Not available'}';

    // In a real app, this would use the share plugin
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location copied to clipboard'),
      ),
    );
  }

  void _copyCoordinates() {
    if (_currentPosition == null) return;

    final coordinates =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';

    // In a real app, this would use the clipboard plugin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coordinates copied: $coordinates'),
      ),
    );
  }
}
