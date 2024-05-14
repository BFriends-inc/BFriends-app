// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
//import 'dart:html';

import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  StreamSubscription? mapSubscription;
  LatLng? _currentPosition;

  static const LatLng _nthuUniversity = LatLng(24.7961, 120.9967);

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  void dispose() {
    mapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(
              child: Text('Fetching map...'),
            )
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition:
                  const CameraPosition(target: _nthuUniversity, zoom: 13),
              markers: {
                const Marker(
                    markerId: MarkerId("_randomLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _nthuUniversity),
                Marker(
                    markerId: const MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure),
                    position: _currentPosition!),
              },
            ),
    );
    
  }

  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    const double minChangeDistance = 0.01;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    mapSubscription = _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng newPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        if (_currentPosition == null || (newPosition.latitude - _currentPosition!.latitude).abs() > minChangeDistance ||
         (newPosition.longitude - _currentPosition!.longitude).abs() > minChangeDistance) {
          setState(() {
            _currentPosition = newPosition;
            _cameraPosition(_currentPosition!);
          });
        }
      }
    });
  }
}
