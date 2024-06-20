import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/models/message.dart';
import 'package:bfriends_app/repositories/message_repo.dart';

class AllMessagesViewModel with ChangeNotifier {
  final MessageRepository _messageRepository;
  StreamSubscription<List<Message>>? _messagesSubscription;

  List<Message> _messages = [];
  List<Message> get messages => _messages;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  AllMessagesViewModel({MessageRepository? messageRepository})
      : _messageRepository = messageRepository ?? MessageRepository() {
    _messagesSubscription = _messageRepository.streamMessages().listen(
      (messages) {
        _isInitializing = false;
        _messages = messages;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  Future<String> addMessage(Message newMessage) async {
    return await _messageRepository.addMessage(newMessage);
  }

  Future<void> deleteMessage(String messageId) async {
    await _messageRepository.deleteMessage(messageId);
  }
}
