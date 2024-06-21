import 'dart:ui';

import 'package:bfriends_app/services/map_controller_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bfriends_app/pages/home_page.dart';
import 'dart:math';
import 'dart:async';

class MarkerProvider with ChangeNotifier {
  Set<Marker> _markers = {};
  late Timer _timer;
  final MapControllerService _mapController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BitmapDescriptor? customIcon;
  MarkerId? selectedMarker;
  Map<String, dynamic>? markerDetail;

  MarkerProvider(this._mapController) {
    _mapController.addListener(_onLocationUpdated);
    _loadCustomMarker();
    _startFetchingMarkers();
  }

  Set<Marker> get markers => _markers;

  Future<void> _loadCustomMarker() async {
    final markerIcon =
        await getBytesFromAsset('assets/images/sports_marker.png', 150);
    customIcon = BitmapDescriptor.fromBytes(
      markerIcon, /*size: const Size(515, 590)*/
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _fetchEventData(String eventId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('events').doc(eventId).get();
      debugPrint("Event name is: $eventId");
      markerDetail = {
        'name': doc['eventName'],
        'imgURL': doc['imageUrl'],
        'date': doc['date'].toDate(),
        'startTime': doc['startTime'],
        'endTime': doc['endTime'],
        'capacity': doc['participants'],
        'joinNum': doc['participationList'],
        'placeName': doc['place']['placeName']
      };
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
    return;
  }

  /// select the marker and update the current selection.
  void _onMarkerTapped(MarkerId marker) async {
    debugPrint(' $marker got tapped');
    if (selectedMarker != marker) selectedMarker = marker;
    await _fetchEventData(selectedMarker!.value);
  }

  /// unselect the current selected marker.
  void unselectMarker() {
    selectedMarker = null;
    markerDetail = null;
  }

  /// Listen to the location update from the map controller
  void _onLocationUpdated() {
    fetchMarkers();
  }

  /// refresh marker on the map every 3 seconds, can be useful when user is idle.
  /// Force the page to refresh new markers within the user's vicinity.
  void _startFetchingMarkers() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchMarkers();
    });
  }

  /// Filter for markers within 5km of the user and display on the map.
  Future<void> fetchMarkers() async {
    try {
      LatLng? userLocation = _mapController.currentPosition;
      if (userLocation == null) return;

      QuerySnapshot snapshot = await _firestore.collection('events').get();
      Set<Marker> fetchedMarkers = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Marker(
          markerId: MarkerId(doc.id),
          position:
              LatLng(data['place']['latitude'], data['place']['longitude']),
          icon: customIcon!,
          onTap: () {
            debugPrint('create event pill');
            //debugPrint(doc.id);
            _onMarkerTapped(MarkerId(doc.id));
          },
        );
      }).toSet();

      Set<Marker> filteredMarkers = fetchedMarkers.where((marker) {
        double distanceInMeters = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );
        return distanceInMeters <= 5000; // 5km range
      }).toSet();

      if (_markers != filteredMarkers) {
        _markers = filteredMarkers;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching markers: $e');
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // meters
    double dLat = _degToRad(end.latitude - start.latitude);
    double dLon = _degToRad(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(start.latitude)) *
            cos(_degToRad(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degToRad(double degree) {
    return degree * (pi / 180);
  }

  @override
  void dispose() {
    _timer.cancel();
    _mapController.removeListener(_onLocationUpdated);
    super.dispose();
  }
}
