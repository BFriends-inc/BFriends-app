import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  EventDetailsScreen({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final eventService = EventService();
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final bool isOwner = user?.uid == event['ownerId'];

    final eventId = event['eventId'] ?? 'No id';
    final image = NetworkImage(event['imageUrl']);
    final eventName = event['eventName'] ?? 'No name';
    final eventDate = event['date'] != null ? (event['date'] as Timestamp).toDate().toIso8601String() : 'No date';
    final startTime = event['startTime'] ?? 'No time';
    final endTime = event['endTime'] ?? 'No time';
    final location = event['place']['placeName'] ?? 'No name';
    final List<dynamic> participantsList = event['participationList'];
    final participants = event['participationList'].length.toString();
    final maxParticipants = event['participants'] ?? "No limit specified";

    final latitude = event['place']['latitude'];
    final longitude = event['place']['longitude'];
    const googleMapsApiKey = 'AIzaSyDyS54e5Iu_jFGV3YiKGv5yg3fiUJiH87A';

    String staticMapUrl = 'https://maps.googleapis.com/maps/api/staticmap'
      '?center=$latitude,$longitude'
      '&zoom=13'
      '&scale=1'
      '&size=600x300'
      '&maptype=roadmap'
      '&key=$googleMapsApiKey'
      '&format=png'
      '&visual_refresh=true'
      '&markers=size:mid%7Ccolor:0xff0000%7Clabel:1%7C$latitude,$longitude';  

    debugPrint(staticMapUrl);

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard(
                context,
                title: 'Event name',
                value: eventName,
                icon: isOwner ? Icons.edit : null, // Conditionally display the icon
              ),
              _buildDetailCard(
                context,
                title: 'Date',
                value: '${eventDate.substring(8, 10)}/${eventDate.substring(5, 7)}/${eventDate.substring(0, 4)} From $startTime to $endTime',
                icon: isOwner ? Icons.edit : null, // Conditionally display the icon
              ),
              _buildDetailCard(
                context,
                title: 'Location',
                value: location,
                icon: isOwner ? Icons.edit : null, // Conditionally display the icon
                child: Container(
                  height: 150,                  
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey,
                  child: Center(
                    child: Image.network(
                      staticMapUrl,
                      fit: BoxFit.cover, // Adjust the fit property
                      width: double.infinity,
                      height: 150,
                    ),
                  ),
                ),
              ),
              _buildDetailCard(
                context,
                title: 'Participants: $participants/$maxParticipants',
                value: '',
                icon: isOwner ? Icons.edit : null, // Conditionally display the icon
                child: FutureBuilder<List<Widget>>(
                  future: _buildParticipantsList(participantsList, authService),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading participants'));
                    } else {
                      return Column(children: snapshot.data ?? []);
                    }
                  },
                ),
              ),
              if (isOwner) // Conditionally display the cancel button
                Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  _buildActionButton(context, 'Cancel Event', Colors.grey),
                  _buildActionButton(context, 'Chat', Colors.blue),
                  ],
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> _buildParticipantsList(List<dynamic> participantsList, AuthService authService) async {
    List<Widget> participantsWidgets = [];

    for (var participant in participantsList) {
      String uid = participant.toString();
      UserModel? userDetails = await authService.fetchUserData(uid);
      String name = userDetails?.username ?? "Unknown";
      bool isHost = event['ownerId'] == uid;
      String imageUrl = userDetails?.avatarURL ?? "";
      participantsWidgets.add(_buildParticipantRow(name, isHost, false, imageUrl));
    }

    return participantsWidgets;
  }
  
  Widget _buildDetailCard(BuildContext context,
      {required String title,
      required String value,
      IconData? icon, // Make icon nullable
      Widget? child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (icon != null) Icon(icon, size: 20), // Conditionally display the icon
              ],
            ),
            if (value.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantRow(String name, bool isHost, bool isConfirmed, String imageUrl) {
    debugPrint(imageUrl);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/images/avatar_placeholder.jpg') as ImageProvider,
        ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (isHost) ...[
            const Text('Host', style: TextStyle(color: Colors.green)),
          ],
          if (!isHost) ...[
            Checkbox(value: isConfirmed, onChanged: (value) {}),
            Icon(Icons.person, color: isConfirmed ? Colors.green : Colors.grey),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
