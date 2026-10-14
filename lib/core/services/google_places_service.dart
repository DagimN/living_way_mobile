import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/places.dart';
import '../config/env.dart';

class GooglePlacesService {
  GooglePlacesService()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );

  final Dio _dio;

  void dispose() {
    _dio.close();
  }

  Future<List<PlaceSuggestion>> autocomplete(String input) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'https://places.googleapis.com/v1/places:autocomplete',
      data: {'input': input},
      options: Options(
        headers: {
          'X-Goog-Api-Key': googleMapsApiKey,
          'X-Goog-FieldMask':
              'suggestions.placePrediction.placeId,suggestions.placePrediction.text.text',
        },
      ),
    );

    final suggestions = response.data?['suggestions'] as List<dynamic>? ?? [];
    return suggestions
        .whereType<Map<String, dynamic>>()
        .map((suggestion) =>
            suggestion['placePrediction'] as Map<String, dynamic>?)
        .whereType<Map<String, dynamic>>()
        .map((prediction) => PlaceSuggestion(
              placeId: prediction['placeId'] as String,
              description: (prediction['text'] as Map<String, dynamic>)['text']
                  as String,
            ))
        .toList();
  }

  Future<PlaceDetails> getPlaceDetails(
    String placeId, {
    String fallbackAddress = '',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://places.googleapis.com/v1/places/${Uri.encodeComponent(placeId)}',
      options: Options(
        headers: {
          'X-Goog-Api-Key': googleMapsApiKey,
          'X-Goog-FieldMask': 'formattedAddress,location',
        },
      ),
    );

    final data = response.data;
    final location = data?['location'] as Map<String, dynamic>?;
    if (data == null || location == null) {
      throw const FormatException('Place details did not include a location.');
    }

    return PlaceDetails(
      address: data['formattedAddress'] as String? ?? fallbackAddress,
      coordinates: LatLng(
        (location['latitude'] as num).toDouble(),
        (location['longitude'] as num).toDouble(),
      ),
    );
  }

  Future<String?> reverseGeocode(LatLng coordinates) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'latlng': '${coordinates.latitude},${coordinates.longitude}',
        'key': googleMapsApiKey,
      },
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('Reverse geocoding returned no data.');
    }

    final status = data['status'] as String?;
    if (status == 'ZERO_RESULTS') return null;
    if (status != 'OK') {
      throw StateError(
          'Reverse geocoding failed: ${data['error_message'] ?? status}');
    }

    final results = data['results'] as List<dynamic>? ?? [];
    if (results.isEmpty) return null;

    results.sort((resultA, resultB) {
      final addressA = resultA['formatted_address'] as String;
      final addressB = resultB['formatted_address'] as String;

      return addressB.length - addressA.length;
    });

    return (results.first as Map<String, dynamic>)['formatted_address']
        as String?;
  }
}
