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

  static const googleMapsApiKey = 'AIzaSyDyS54e5Iu_jFGV3YiKGv5yg3fiUJiH87A';

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

  Future<String> downloadMapHolderImage(
      String latitude, String longitude, String eventName) async {
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

    // Download the static map image
    var response = await http.get(Uri.parse(staticMapUrl));
    if (response.statusCode == 200) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String mapFilePath = '${appDocDir.path}/map_$eventName.png';
      await File(mapFilePath).writeAsBytes(response.bodyBytes);

      // Upload the static map image to Firebase Storage
      final mapHolderRef =
          _storage.ref().child('eventMapHolderImages').child('$eventName.jpg');
      await mapHolderRef.putFile(File(mapFilePath));
      String mapHolderImgUrl = await mapHolderRef.getDownloadURL();

      // Delete the local file
      await File(mapFilePath).delete();
      return mapHolderImgUrl;
    } else {
      throw Exception('Failed to download map image from $staticMapUrl');
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

      if (selectedImage.path.startsWith('http') ||
          selectedImage.path.startsWith('https')) {
        // Generate a unique file name for the temporary file
        String tempFileName = '${uuid.v4()}.png';

        // Download the image to a local file
        await downloadImage(selectedImage.path, tempFileName);

        // Get the path of the temporary file
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String tempFilePath = '${appDocDir.path}/$tempFileName';

        // Upload the image directly to Firebase Storage
        final storageRef =
            _storage.ref().child('eventImages').child('$eventName.jpg');
        await storageRef.putFile(File(tempFilePath));
        imageUrl = await storageRef.getDownloadURL();

        // Delete the local file
        await File(tempFilePath).delete();
      } else {
        // Upload the image directly to Firebase Storage
        final storageRef =
            _storage.ref().child('eventImages').child('$eventName.jpg');
        await storageRef.putFile(File(selectedImage.path));
        imageUrl = await storageRef.getDownloadURL();
      }

      String mapHolderImgUrl = await downloadMapHolderImage(
          latitude.toString(), longitude.toString(), eventName);

      // Create event in Firestore
      final eventId = uuid.v4();

      final participationList = {
        ownerId: {'isConfirmed': true}
      };

      final event = {
        'eventId': eventId,
        'ownerId': ownerId,
        'eventName': eventName,
        'participants': participants,
        'imageUrl': imageUrl,
        'mapHolderImgUrl': mapHolderImgUrl,
        'date': DateTime.parse(eventDate),
        'startTime': eventStartTime,
        'endTime': eventEndTime,
        'place': {
          'placeName': placeName,
          'placeAddress': placeAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        'participationList': participationList,
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
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  Future<Map<String, dynamic>?> getEventById(String eventId) async {
    try {
      DocumentSnapshot eventDoc =
          await _firestore.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        return eventDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }

  Future<void> joinEvent(String eventId, String userId) async {
    try {
      final event = _firestore.collection('events').doc(eventId);
      final eventDoc = await event.get();
      final eventOwner = eventDoc.get('ownerId');
      final participationList =
          Map<String, dynamic>.from(eventDoc.get('participationList'));
      final maxParticipants = int.parse(eventDoc.get('participants'));

      if (participationList.length < maxParticipants) {
        if (!participationList.keys.contains(userId)) {
          participationList[userId] = {'isConfirmed': false};
          debugPrint(participationList.toString());
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

  Future<void> updateEvent(
      String eventId, Map<String, dynamic> updatedData) async {
    try {
      debugPrint("Updating event: $updatedData");
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .update(updatedData);
      String eventName = (await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get())
          .get('eventName');
      if (updatedData.containsKey('place')) {
        String mapHolderImgUrl = await downloadMapHolderImage(
            updatedData['place']['latitude'].toString(),
            updatedData['place']['longitude'].toString(),
            eventName);
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .update({'mapHolderImgUrl': mapHolderImgUrl});
      }
      debugPrint("Event updated successfully");
    } catch (e) {
      debugPrint("Error updating event: $e");
      throw e;
    }
  }

  Future<void> removeParticipant(String eventId, String userId) async {
    try {
      // Remove the participant from the event
      await _firestore.collection('events').doc(eventId).update({
        'participationList': FieldValue.arrayRemove([userId]),
      });
      debugPrint('Participant removed successfully');
    } catch (e) {
      debugPrint('Error removing participant: $e');
      throw Exception('Failed to remove participant');
    }
  }

  Future<void> cancelEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      throw Exception('Failed to cancel event: $e');
    }
  }
}
