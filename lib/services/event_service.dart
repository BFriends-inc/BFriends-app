import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid uuid = const Uuid();

  Future<void> downloadImage(String url, String fileName) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';
      await File(filePath).writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download image from $url');
    }
  }
  
  Future<void> createEvent({
    required String ownerId,
    required String eventName,
    required String participants,
    required XFile selectedImage,
    required String eventDate,
    required String eventStartTime,
    required String eventEndTime,
    required String placeName,
    required String placeAddress,
    required double latitude,
    required double longitude,
  }) async {
    try {
      String imageUrl;

      if (selectedImage.path.startsWith('http') || selectedImage.path.startsWith('https')) {
        // Generate a unique file name for the temporary file
        String tempFileName = '${uuid.v4()}.png';

        // Download the image to a local file
        await downloadImage(selectedImage.path, tempFileName);

        // Get the path of the temporary file
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String tempFilePath = '${appDocDir.path}/$tempFileName';

        // Upload the image directly to Firebase Storage
        final storageRef = _storage.ref().child('eventImages').child('$eventName.jpg');
        await storageRef.putFile(File(tempFilePath));
        imageUrl = await storageRef.getDownloadURL();

        // Delete the local file
        await File(tempFilePath).delete();
      } else {
        // Upload the image directly to Firebase Storage
        final storageRef = _storage.ref().child('eventImages').child('$eventName.jpg');
        await storageRef.putFile(File(selectedImage.path));
        imageUrl = await storageRef.getDownloadURL();
      }

      // Create event in Firestore
      final eventId = uuid.v4();
      debugPrint(eventId);
      final event = {
        'eventId': eventId,
        'ownerId': ownerId,
        'eventName': eventName,
        'participants': participants,
        'imageUrl': imageUrl,
        'date': DateTime.parse(eventDate),
        'startTime': eventStartTime,
        'endTime': eventEndTime,
        'place': {
          'placeName': placeName,
          'placeAddress': placeAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        'participationList': [ownerId],
      };
      await _firestore.collection('events').doc(eventId).set(event);
      debugPrint('Event created successfully!');
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('events').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  Future<void> joinEvent(String eventId, String userId) async {
    try {
      final event = _firestore.collection('events').doc(eventId);
      final eventDoc = await event.get();
      final eventOwner = eventDoc.get('ownerId');
      final participationList = eventDoc.get('participationList');
      final maxParticipants = int.parse(eventDoc.get('participants'));

      if (participationList.length < maxParticipants) {
        if (!participationList.contains(userId)) {
          participationList.add(userId);
          await event.update({'participationList': participationList});
          debugPrint('Joined event $eventId');
        } else {
          debugPrint('User already joined event $eventId');
        }
      } else {
        debugPrint('Event $eventId is full');
      }
    } catch (e) {
      throw Exception('Error joining event: $e');
    }
  }
}