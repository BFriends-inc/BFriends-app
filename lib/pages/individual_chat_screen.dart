import 'package:bfriends_app/model/friend.dart';
import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class IndividualChatScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final User? currUser;
  final Friend? friend;

  const IndividualChatScreen({Key? key, required this.event, required this.currUser, required this.friend})
      : super(key: key);

  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  late String chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.event['relationshipId'];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.event.toString());
    return Scaffold(
      appBar: AppBar(
        title: widget.friend?.username != null
            ? Text(widget.friend!.username)
            : const Text('Individual Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getPrivateMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No messages'));
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(message['avatarURL']),
                      ),
                      title: Text(message['username']),
                      subtitle: Text(message['message']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (widget.currUser != null &&
                        _messageController.text.isNotEmpty) {
                      _chatService.sendPrivateMessage(chatId, widget.currUser!.uid,
                          _messageController.text);
                      _messageController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('User not logged in or message is empty'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
