import 'location.dart';

class GoogleGeocodingGeometry {
  const GoogleGeocodingGeometry({
    required this.location,
    required this.locationType,
  });

  factory GoogleGeocodingGeometry.fromJson(Map<String, dynamic> json) =>
      GoogleGeocodingGeometry(
        location: GoogleGeocodingLocation.fromJson(
          json['location'] as Map<String, dynamic>,
        ),
        locationType: json['location_type'] as String? ?? '',
      );
  final GoogleGeocodingLocation location;
  final String locationType;

  /// More info at
  /// https://developers.google.com/maps/documentation/geocoding/overview#Viewports
}
