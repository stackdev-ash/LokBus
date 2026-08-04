import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// GeocodingService handles geocoding operations (converting coordinates to addresses)
class GeocodingService {
  // Convert lat/lng → Address
  static Future<String> getPlaceName(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.locality}, ${placemark.subLocality}, ${placemark.administrativeArea}";
      } else {
        return "Unknown Location";
      }
    } catch (e) {
      return "Error getting place name: $e";
    }
  }

  // Convert coordinates to address string
  static Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.locality}, ${placemark.subLocality}, ${placemark.administrativeArea}";
      } else {
        return "Unknown Location";
      }
    } catch (e) {
      return "Error getting address: $e";
    }
  }
}
