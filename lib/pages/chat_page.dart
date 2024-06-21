import 'package:flutter/material.dart';
import 'package:bfriends_app/model/friend.dart';
import 'chat_storage.dart'; // Import your ChatStorage class

class ChatPage extends StatefulWidget {
  final Friend friend;

  const ChatPage({required this.friend, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      _messages.addAll(ChatStorage.getMessages(widget.friend.name));
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        ChatStorage.addMessage(
            widget.friend.name, _controller.text); // Save message to storage
        _controller.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessage(String message, bool isMe) {
    final theme = Theme.of(context);
    final bg = isMe
        ? theme.colorScheme.secondary
        : const Color.fromARGB(255, 222, 216, 225);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              backgroundImage: AssetImage(widget.friend.imagePath),
            ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: align,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: radius,
                ),
                child: Text(
                  message,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add more actions if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                // FOR NOW THE MESSAGES ARE ALTERNATING BETWEEN SENDER AND RECEIVER
                final isMe = index % 2 == 0;
                return _buildMessage(message, isMe);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
