import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final ImageProvider image;
  final String eventName;
  final String eventDate;
  final String startTime;
  final String endTime;
  final String location;
  final String participants;
  final String maxParticipants;
  final bool isFull;

  EventCard({
    required this.image,
    required this.eventName,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.participants,
    required this.maxParticipants,
    required this.isFull,
  });

  @override
  Widget build(BuildContext context) {    
    return Card(
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
            padding: const EdgeInsets.all(10.0), // Adjust the padding here
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: isFull ? Colors.blue : Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: Text(
                      isFull ? 'FULL' : 'JOIN',
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
    );
  }
}
