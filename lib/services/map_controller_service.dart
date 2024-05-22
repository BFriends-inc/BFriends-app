import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapControllerService extends ChangeNotifier {
  static final MapControllerService _instance =
      MapControllerService._internal();

  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location _locationController = Location();
  LatLng? currentPosition;
  StreamSubscription<LocationData>? locationSubscription;

  factory MapControllerService() {
    return _instance;
  }

  MapControllerService._internal() {
    initialize();
  }

  void initialize() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permission = await _locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _locationController.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      updateLocation(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
    });
  }

  void updateLocation(LatLng newPosition) {
    if (currentPosition == null || currentPosition != newPosition) {
      currentPosition = newPosition;
      notifyListeners();
      animateToCurrentLocation();
    }
  }

  bool _isAnimating = false;

  Future<void> animateToCurrentLocation() async {
    if (!_isAnimating && currentPosition != null) {
      _isAnimating = true;
      final GoogleMapController controller = await _mapController.future;
      final CameraPosition position =
          CameraPosition(target: currentPosition!, zoom: 18);
      await controller.animateCamera(CameraUpdate.newCameraPosition(position));
      _isAnimating = false;
    }
  }

  void setMapController(GoogleMapController controller) {
    debugPrint("Entering setup");
    if (!_mapController.isCompleted) {
      debugPrint("Completed controller");
      _mapController.complete(controller);
    } else {
      _mapController = Completer()..complete(controller);
    }
  }

  @override
  void dispose() {
    debugPrint("disposed");
    locationSubscription?.cancel();
    super.dispose();
  }
}
