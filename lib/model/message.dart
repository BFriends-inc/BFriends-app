import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message{
  String? id;
  final String text;

  final String userId;
  final String userName;
  final String userAvatarUrl;

  Timestamp? _createdDate;
  Timestamp get createdDate => _createdDate ?? Timestamp.now();

  Message({
    required this.text,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
  });

  Message._({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required Timestamp? createdDate,
  }) : _createdDate = createdDate;

  factory Message.fromMap(Map<String, dynamic> map, String id) {
    return Message._(
      id: id,
      text: map['text'],
      userId: map['userId'],
      userName: map['userName'],
      userAvatarUrl: map['userAvatarUrl'],
      createdDate: map['createdDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'createdDate': createdDate,
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Message && runtimeType == other.runtimeType && id == other.id; 

  @override
  int get hashCode => id.hashCode;
}

class MessageBubble extends StatelessWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  MessageBubble.withUser({
    super.key,
    required this.userAvatarUrl,
    required this.userName,
    required this.text,
    required this.isMine,
    required this.isLast,
    this.onDelete,
  });

  // Create a amessage bubble that continues the sequence.
  MessageBubble({
    super.key,
    required this.text,
    required this.isMine,
    required this.isLast,
    this.onDelete,
  })  : userAvatarUrl = null,
        userName = null;

  // Whether this message bubble is the last in a sequence of messages from the same user. Modifies the message bubble slightly for these different cases - only shows user image for the first message from the same user, and changes the shape of the bubble for messages thereafter.
  final bool isLast;

  // Image of the user to be displayed next to the bubble. Not required if the message is not the first in a sequence.
  final String? userAvatarUrl;

  // Username of the user.  Not required if the message is not the first in a sequence.
  final String? userName;
  final String text;

  // Controls how the MessageBubble will be aligned.
  final bool isMine;

  // Callback to delete the message.
  Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (!isMine && userAvatarUrl != null)
          Positioned(
            top: 16,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userAvatarUrl!,
              ),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 12,
            ),
          ),
        Container(
          // Add some margin to the edges of the messages, to allow space for the user's image.
          margin: EdgeInsets.symmetric(horizontal: isMine ? 0 : 24),
          child: Row(
            // The side of the chat screen the message should show at.
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // First messages in the sequence provide a visual buffer at the top.
                  if (!isMine && userName != null) const SizedBox(height: 18),
                  if (!isMine && userName != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 4,
                      ),
                      child: Text(
                        userName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Column(
                    // The "speech" box surrounding the message.
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isMine
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primaryContainer,
                          // Only show the message bubble's "speaking edge" if first in the chain. Whether the "speaking edge" is on the left or right depends on whether or not the message bubble is the current user.
                          borderRadius: BorderRadius.only(
                            topLeft: !isMine
                                ? Radius.zero
                                : const Radius.circular(16),
                            topRight: isMine
                                ? Radius.zero
                                : const Radius.circular(16),
                            bottomLeft: isMine || isLast
                                ? const Radius.circular(16)
                                : Radius.zero,
                            bottomRight: !isMine || isLast
                                ? const Radius.circular(16)
                                : Radius.zero,
                          ),
                        ),
                        // Set some reasonable constraints on the width of the message bubble so it can adjust to the amount of text it should show.
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        // Margin around the bubble.
                        margin: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                // Add a little line spacing to make the text look nicer when multilined.
                                height: 1.3,
                                color: isMine
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onPrimaryContainer,
                              ),
                              softWrap: true,
                            ),
                            if (onDelete != null)
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: isMine
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onPrimaryContainer,
                                ),
                                color: theme.colorScheme.onPrimary,
                                onPressed: onDelete,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
