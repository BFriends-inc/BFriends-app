import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bfriends_app/services/map_controller_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>
    with AutomaticKeepAliveClientMixin<MapPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    super.build(context);

    final mapControllerService = Provider.of<MapControllerService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'BFriends',
          style: TextStyle(
              fontSize: theme.primaryTextTheme.headlineMedium?.fontSize,
              fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight,
              color: theme.colorScheme.onPrimary),
        ),
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
      body: mapControllerService.currentPosition == null
          ? const Center(child: Text('Fetching map...'))
          : GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              padding: const EdgeInsets.only(bottom: 65.0, right: 5.0),
              onMapCreated: mapControllerService.setMapController,
              initialCameraPosition: CameraPosition(
                target: mapControllerService.currentPosition!,
                zoom: 18,
              ),
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
