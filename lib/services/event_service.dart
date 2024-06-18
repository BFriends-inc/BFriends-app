import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid uuid = const Uuid();

  Future<void> createEvent({
    required String ownerId,
    required String eventName,
    required String participants,
    required XFile selectedImage,
    required String eventDate,
    required String placeName,
    required String placeAddress,
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Upload image to Firebase Storage
      final storageRef = _storage.ref().child('eventImages').child('$eventName.jpg');
      await storageRef.putFile(File(selectedImage.path));
      String imageUrl = await storageRef.getDownloadURL();

      // Create event in Firestore
      final eventId = uuid.v4();
      debugPrint(eventId);
      final event = {
        'ownerId': ownerId,
        'eventName': eventName,
        'participants': participants,
        'imageUrl': imageUrl,
        'date': DateTime.parse(eventDate),
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
}