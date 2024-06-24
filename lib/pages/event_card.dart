import 'package:bfriends_app/pages/event_detail.dart';
import 'package:bfriends_app/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final User? currUser;
  final bool isFull;
  final String userId;
  final bool isHosted;
  final bool isJoined;

  EventCard({
    required this.event,
    required this.currUser,
    required this.userId,
    required this.isFull,
    required this.isHosted,
    required this.isJoined,
  });

  @override
  Widget build(BuildContext context) {
    final eventService = EventService();
    final eventId = event['eventId'] ?? 'No id';
    final image = NetworkImage(event['imageUrl']);
    final eventName = event['eventName'] ?? 'No name';
    final eventDate = event['date'] != null ? (event['date'] as Timestamp).toDate().toIso8601String() : 'No date';
    final startTime = event['startTime'] ?? 'No time';
    final endTime = event['endTime'] ?? 'No time';
    final location = event['place']['placeName'] ?? 'No name';
    final Map<String, dynamic> participantsList = event['participationList'];
    final participants = event['participationList'].length.toString();
    final maxParticipants = event['participants'] ?? "No limit specified";
    final currentUser = currUser;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(
              event: event,
              currUser: currUser,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image(
                image: image,
                fit: BoxFit.cover,
                height: 100.0,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '@ $location',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '${eventDate.substring(8, 10)}/${eventDate.substring(5, 7)}/${eventDate.substring(0, 4)} From $startTime to $endTime',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '$participants / $maxParticipants Going',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: isHosted
                            ? Colors.grey
                            : isJoined
                                ? Colors.grey
                                : isFull
                                    ? Colors.red
                                    : Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        if (!isHosted && !isFull) {
                          eventService.joinEvent(eventId, userId);
                        }
                      },
                      child: Text(
                        isHosted
                            ? 'HOSTED'
                            : isJoined
                                ? 'JOINED'
                                : isFull
                                    ? 'FULL'
                                    : 'JOIN',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
