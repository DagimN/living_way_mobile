import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:living_way/core/core.dart';

class MapController extends ChangeNotifier {
  static const _defaultLocation = LatLng(9.008, 38.760);

  final addressTextController = TextEditingController();
  final placeService = GooglePlacesService();

  Profile? profile;
  LatLng? _selectedCoordinates;
  LatLng? _cameraTarget;
  GoogleMapController? _mapController;

  String address = '';

  MapController({required this.profile, PlaceDetails? place}) {
    _selectedCoordinates =
        place?.coordinates ?? profile?.coordinates ?? _defaultLocation;
    _cameraTarget = _selectedCoordinates;
    address = place?.address ?? profile?.address ?? '';
    addressTextController.text = address;
  }

  LatLng get getPosition => _selectedCoordinates ?? _defaultLocation;

  set setGoogleMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  set setCameraTarget(LatLng value) {
    _cameraTarget = value;
  }

  set setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void onCameraIdle() {
    final coordinates = _cameraTarget;

    if (coordinates == null) return;

    _selectedCoordinates = coordinates;

    notifyListeners();
  }

  void onPlaceSelected(PlaceDetails place) {
    _cameraTarget = place.coordinates;

    _selectedCoordinates = place.coordinates;
    address = place.address ?? "";
    notifyListeners();

    if (place.coordinates != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(place.coordinates!, 17),
      );
    }
  }

  @override
  void dispose() {
    addressTextController.dispose();
    placeService.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
