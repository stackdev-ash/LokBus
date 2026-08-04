import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// LocationService handles permission flow and location updates.
class LocationService {
  StreamSubscription<Position>? _positionSub;

  /// Ensure location permission and services enabled
  Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return false;
    }

    return true;
  }

  /// ✅ One-time location fetch
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Start streaming location updates
  Future<void> startListening({
    required void Function(Position position) onPosition,
    LocationSettings? settings,
  }) async {
    final allowed = await ensurePermission();
    if (!allowed) {
      throw Exception('Location permission not granted or services disabled');
    }

    final effectiveSettings =
        settings ??
        const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10, // meters
        );

    await stopListening();

    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: effectiveSettings,
        ).listen(
          (position) {
            try {
              onPosition(position);
            } catch (e, st) {
              if (kDebugMode) {
                print('onPosition handler error: $e\n$st');
              }
            }
          },
          onError: (error) {
            if (kDebugMode) {
              print('Location stream error: $error');
            }
          },
          cancelOnError: false,
        );
  }

  /// Stop streaming
  Future<void> stopListening() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

  bool get isListening => _positionSub != null;
}
