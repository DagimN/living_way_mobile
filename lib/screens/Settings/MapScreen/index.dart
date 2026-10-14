import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'widgets/places_autocomplete_field.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return Consumer<MapController>(builder: (context, mapController, _) {
      final address = mapController.address;
      final selectedCoordinates = mapController.getPosition;

      return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          title: Text(Tr.t('mapLocation')),
          backgroundColor: theme.backgroundColor,
          foregroundColor: theme.primaryColor,
          systemOverlayStyle: theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
        ),
        body: googleMapsApiKey.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Google Maps is not configured. Add GOOGLE_MAPS_API_KEY to .env, '
                    'android/local.properties, and ios/Flutter/GoogleMaps.local.xcconfig, '
                    'then enable Maps SDK, Places API (New), and Geocoding API in Google Cloud.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: mapController.getPosition,
                      zoom: 16,
                    ),
                    onMapCreated: (controller) =>
                        mapController.setGoogleMapController = controller,
                    onCameraMove: (position) =>
                        mapController.setCameraTarget = position.target,
                    onCameraIdle: mapController.onCameraIdle,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  const IgnorePointer(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 36),
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: PlacesAutocompleteField(
                        controller: mapController.addressTextController,
                        style: TextStyle(color: theme.accentColor),
                        decoration: InputDecoration(
                          hintText: Tr.t('searchAddress'),
                          filled: true,
                          fillColor: theme.backgroundColor,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) => mapController.setAddress = value,
                        onPlaceSelected: mapController.onPlaceSelected,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: SafeArea(
                      top: false,
                      child: Card(
                        color: theme.backgroundColor,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                Tr.t('moveMapPin'),
                                style: TextStyle(
                                  color: theme.accentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (address.isNotEmpty)
                                Text(
                                  address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: theme.accentColor),
                                ),
                              if (selectedCoordinates case final coordinates)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '${coordinates.latitude.toStringAsFixed(6)}, '
                                    '${coordinates.longitude.toStringAsFixed(6)}',
                                    style: TextStyle(
                                      color: theme.accentColor
                                          .withValues(alpha: .7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pop(
                                  context,
                                  PlaceDetails(
                                    address: address,
                                    coordinates: selectedCoordinates,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                icon: const Icon(Icons.check),
                                label: Text(Tr.t('useThisLocation')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
