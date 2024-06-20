//import 'dart:typed_data';
import 'dart:ui';
import 'package:bfriends_app/services/marker_service.dart';
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
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    super.build(context);

    final mapControllerService = Provider.of<MapControllerService>(context);
    final markerService = Provider.of<MarkerProvider>(context);

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
                  markers: markerService.markers
                  // {
                  // Marker(
                  //   markerId: const MarkerId('custom_marker'),
                  //   position: mapControllerService.currentPosition!,
                  //   icon: customIcon!,
                  //   onTap: () {
                  //     debugPrint('create pill');
                  //     _onMarkerTapped(
                  //         const Marker(markerId: MarkerId('oompa')));
                  //   },
                  // ),
                  // }
                  ,
                  onTap: (argument) {
                    //user tapped on map, unselect the any current selection.
                    markerService.unselectMarker();
                  },
                ),
                if (markerService.selectedMarker != null)
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
