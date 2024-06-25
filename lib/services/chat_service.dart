import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    bool _isRequestingPermission = false;
    debugPrint('Initializing ChatService...');

    if (!_isRequestingPermission) {
      _isRequestingPermission = true;

      try {
        NotificationSettings settings =
            await _firebaseMessaging.requestPermission();
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
        _isRequestingPermission = false;
      }
    }
  }

  Future<void> sendGroupMessage(
      String chatId, String userId, String groupName, String message) async {
    DocumentSnapshot<Object?> user = await getUserData(userId);
    await _firestore
        .collection('groupChats')
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

  Future<void> sendPrivateMessage(
      String chatId, String userId, String message) async {
    DocumentSnapshot<Object?> user = await getUserData(userId);
    await _firestore
        .collection('privateChats')
        .doc(chatId)
        .collection('messages')
        .add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'avatarURL': user['avatarURL'] ?? "",
      'username': user['username'] ?? "",
    });
  }

  Stream<QuerySnapshot> getGroupMessages(String chatId) {
    return _firestore
        .collection('groupChats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPrivateMessages(String chatId) {
    return _firestore
        .collection('privateChats')
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

  Future<Map<String, dynamic>> getRelationshipData(
      String relationshipId) async {
    final doc =
        await _firestore.collection('relationships').doc(relationshipId).get();
    return doc.data()!;
  }

  Stream<List<Map<String, dynamic>>> getUserRelationships(String userId) {
    return _firestore
        .collection('relationships')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
