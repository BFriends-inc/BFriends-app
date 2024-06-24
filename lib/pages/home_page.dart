//import 'dart:typed_data';
import 'dart:ui';
import 'package:bfriends_app/services/navigation.dart';
import 'package:bfriends_app/widget/event_pill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bfriends_app/services/map_controller_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin<MapPage> {
  BitmapDescriptor? customIcon;
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadCustomMarker() async {
    final markerIcon =
        await getBytesFromAsset('assets/images/sports_marker.png', 150);
    customIcon = BitmapDescriptor.fromBytes(
      markerIcon, /*size: const Size(515, 590)*/
    );
    setState(() {});
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

  void _onMarkerTapped(Marker marker) {
    setState(() {
      debugPrint('got tapped');
      if (_selectedMarker != marker) _selectedMarker = marker;
    });
  }

  void _onMapTapped() {
    setState(() {
      _selectedMarker = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    super.build(context);

    final mapControllerService = Provider.of<MapControllerService>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.onPrimary,
                semanticLabel: 'Notifications',
              ),
              onPressed: () {
                //context.pop();
                final nav =
                    Provider.of<NavigationService>(context, listen: false);
                nav.goNotification(context: context);
              },
            ),
          ],
        ),
      ),
      body: mapControllerService.currentPosition == null
          ? const Center(child: Text('Fetching map...'))
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  padding: const EdgeInsets.only(bottom: 65.0, right: 5.0),
                  onMapCreated: mapControllerService.setMapController,
                  initialCameraPosition: CameraPosition(
                    target: mapControllerService.currentPosition!,
                    zoom: 18,
                  ),
                  markers: {
                    if (customIcon != null &&
                        mapControllerService.currentPosition != null)
                      Marker(
                        markerId: const MarkerId('custom_marker'),
                        position: mapControllerService.currentPosition!,
                        icon: customIcon!,
                        onTap: () {
                          debugPrint('create pill');
                          _onMarkerTapped(
                              const Marker(markerId: MarkerId('oompa')));
                        },
                      ),
                  },
                  onTap: (argument) {
                    _onMapTapped();
                  },
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: IconButton.filled(
                //     onPressed: () {
                //       final nav = Provider.of<NavigationService>(context,
                //           listen: false);
                //       nav.goNotification(context: context);
                //     },
                //     icon: const Icon(Icons.notifications_none_rounded),
                //   ),
                // ),
                if (_selectedMarker != null)
                  EventPill(
                    pillPosition: 200,
                    title: 'gengar',
                    date: DateTime.now(),
                    imageURL: '111',
                    maxPpl: 1,
                    ppl: 1,
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.location_on),
        onPressed: () {
          if (mapControllerService.currentPosition != null) {
            mapControllerService.animateToCurrentLocation();
          }
        },
      ),
    );
  }
}
