import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceSuggestion {
  final String placeId;
  final String description;

  const PlaceSuggestion({
    required this.placeId,
    required this.description,
  });
}

class PlaceDetails {
  String? address;
  LatLng? coordinates;

  PlaceDetails({
    this.address,
    this.coordinates,
  });
}
