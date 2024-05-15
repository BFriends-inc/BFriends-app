import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bfriends_app/services/map_controller_service.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapControllerService = Provider.of<MapControllerService>(context);

    return Scaffold(
      body: mapControllerService.currentPosition == null
          ? const Center(child: Text('Fetching map...'))
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              padding: const EdgeInsets.only(bottom: 65.0, right: 5.0),
              onMapCreated: mapControllerService.setMapController,
              initialCameraPosition: CameraPosition(
                target: mapControllerService.currentPosition!,
                zoom: 15,
              ),
            ),
      floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (mapControllerService.currentPosition != null) {
                  mapControllerService.animateToCurrentLocation();
                }
              },
              child: const Icon(Icons.location_on),
            ),
    );
  }
}



