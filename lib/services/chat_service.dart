import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    bool isRequestingPermission = false;
    debugPrint('Initializing ChatService...');

    if (!isRequestingPermission) {
      isRequestingPermission = true;

      try {
        NotificationSettings settings = await _firebaseMessaging.requestPermission();
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('User granted permission');

          String? _fcmToken = await _firebaseMessaging.getToken();
          debugPrint('FCM Token: $_fcmToken');

          if (_fcmToken != null) {
            await saveTokenToFirestore(_fcmToken);
          }
        } else {
          debugPrint('User declined or has not accepted permission');
        }
      } catch (e) {
        debugPrint('Error requesting permission or getting token: $e');
      } finally {
        isRequestingPermission = false;
      }
    }
  }

  Future<void> sendMessage(String chatId, String userId, String groupName, String message) async {
    DocumentSnapshot<Object?> user = await getUserData(userId);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'userId': userId,
      'groupName': groupName,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'avatarURL': user['avatarURL'] ?? "",
      'username': user['username'] ?? "",
    });
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  Future<void> saveTokenToFirestore(String token) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
      debugPrint('FCM token saved to Firestore');
    } catch (e) {
      debugPrint('Error saving FCM token to Firestore: $e');
      rethrow;
    }
  }
}
