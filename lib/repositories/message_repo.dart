import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bfriends_app/models/message.dart';

class MessageRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Message>> streamMessages() {
    return _db
        .collection('apps/bfriends/messages')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<String> addMessage(Message message) async {
    Map<String, dynamic> messageMap = message.toMap();
    messageMap.remove('id');
    messageMap['createdDate'] = FieldValue.serverTimestamp();
    DocumentReference docRef = await _db
        .collection('apps/bfriends/messages')
        .add(messageMap);
    return docRef.id;
  }

  Future<void> deleteMessage(String messageId) async {
    await _db
        .collection('apps/bfriends/messages')
        .doc(messageId)
        .delete(); 
  }
}