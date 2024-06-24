import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/widget/notification.dart';
import 'package:bfriends_app/list/notification_list.dart';

class AcceptFriendPage extends StatefulWidget {
  const AcceptFriendPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AcceptFriendPageState createState() => _AcceptFriendPageState();
}

class _AcceptFriendPageState extends State<AcceptFriendPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(username: 'John', pfp: "https://firebasestorage.googleapis.com/v0/b/bfriend-dev.appspot.com/o/userImages%2FXJT3JXokfaexdO0fhpygsyf89Kw2.jpg?alt=media&token=215b9585-0f32-41c1-b791-eb453810dc59"),
    NotificationItem(username: 'Johnny', pfp: "https://firebasestorage.googleapis.com/v0/b/bfriend-dev.appspot.com/o/userImages%2FYpEQPLJCqKPMNX6LJfvSBvAyMss2.jpg?alt=media&token=b2a4bd49-fed7-4a54-a884-bcd138ae9af9"),
    NotificationItem(username: 'Sins', pfp: "https://firebasestorage.googleapis.com/v0/b/bfriend-dev.appspot.com/o/userImages%2F3V0wITDgN1ZGO80FhxaG5O9kZxm1.jpg?alt=media&token=6e97d87c-a062-4b5c-a77f-1abd810a34dd")
  ];

  void _removeNotification(NotificationItem notif) {
    final notifIndex = _notifications.indexOf(notif);
    setState(() {
      _notifications.remove(notif);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('Friend request from ${notif.username} removed'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _notifications.insert(notifIndex, notif);
          });
        },
      ),
    ));
  }

  void _acceptNotification(NotificationItem notif) {
    final notifIndex = _notifications.indexOf(notif);
    setState(() {
      _notifications.remove(notif);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('You are now friends with ${notif.username}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _notifications.insert(notifIndex, notif);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget notifList = const Center(
      child: Text('No new notifications!'),
    );

    if (_notifications.isNotEmpty) {
      notifList = NotificationList(
        notifications: _notifications,
        onRemoveNotification: _removeNotification,
        onAcceptNotification: _acceptNotification,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          title: Text(
            'Requests',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontStyle: theme.textTheme.headlineMedium!.fontStyle,
              fontSize: theme.textTheme.headlineSmall!.fontSize,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: notifList),
      ],),
    );
  }
}
