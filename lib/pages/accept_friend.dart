import 'dart:async';

import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/widget/notification.dart';
import 'package:bfriends_app/list/notification_list.dart';
import 'package:bfriends_app/model/friend.dart';

class AcceptFriendPage extends StatefulWidget {
  const AcceptFriendPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AcceptFriendPageState createState() => _AcceptFriendPageState();
}

class _AcceptFriendPageState extends State<AcceptFriendPage> {
  final List<NotificationItem> _notifications = [];

  void _removeNotification(
      NotificationItem notif, AuthService authService) async {
    final notifIndex = _notifications.indexOf(notif);
    await authService.removeFriendRequest(authService.user?.id ?? '', notif.id);
    setState(() {
      _notifications.remove(notif);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('Friend request from ${notif.username} removed'),
    ));
  }

  void _acceptNotification(
      NotificationItem notif, AuthService authService) async {
    debugPrint('accept notif function');
    final notifIndex = _notifications.indexOf(notif);
    await authService.acceptFriend(authService.user?.id ?? '', notif.id);
    setState(() {
      debugPrint('Accept Friend');
      _notifications.remove(notif);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('You are now friends with ${notif.username}'),
    ));
  }

  Future<void> fetchAllFriends(String uid, AuthService authService) async {
    var user = await authService.fetchUserModelData(
        uid, FirebaseAuth.instance.currentUser!);
    var requests = user?.requests;
    debugPrint('request length: ${requests?.length.toString() ?? '0'}');
    List<Future<Friend>> friendFutures = requests!.map((req) {
      return authService.fetchFriend(req);
    }).toList();

    List<Friend> frd = await Future.wait(friendFutures);
    debugPrint(frd.length.toString());
    for (Friend friend in frd) {
      debugPrint('LOOP: ${friend.username}');
      NotificationItem notif = NotificationItem(
          username: friend.username, pfp: friend.imagePath, id: friend.id);
      // Check for duplicates before adding
      if (_notifications.isEmpty) {
        _notifications.add(notif);
      }
      for (NotificationItem n in _notifications) {
        if (n.id == notif.id) {
          return;
        }
        _notifications.add(notif);
      }
    }
  }

  StreamSubscription? _friendsSubscription;

  void _listenToEvents(String uid, AuthService authService) {
    _friendsSubscription =
        FirebaseFirestore.instance.collection('users').snapshots().listen(
      (snapshot) {
        debugPrint(snapshot.docs.toString());
        fetchAllFriends(uid, authService);
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );
  }

  AuthService? authService;

  @override
  void initState() {
    super.initState();
    debugPrint("INNIT");
    // Fetch authService when initState is called
    authService = Provider.of<AuthService>(context, listen: false);
    fetchAllFriends(FirebaseAuth.instance.currentUser!.uid, authService!);
    //_listenToEvents(FirebaseAuth.instance.currentUser!.uid, authService!);
  }

  @override
  void dispose() {
    //_friendsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = Provider.of<AuthService>(context).user;

    debugPrint('notif length ${_notifications.length.toString()}');

    Widget notifList = const Center(
      child: Text('No new notifications!'),
    );

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
      body: FutureBuilder(
          future: fetchAllFriends(user!.id!, authService),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (_notifications.isNotEmpty) {
                debugPrint('_notifications not empty');
                notifList = NotificationList(
                  notifications: _notifications,
                  onRemoveNotification: _removeNotification,
                  onAcceptNotification: _acceptNotification,
                );
              }
            }
            return Column(
              children: [
                Expanded(child: notifList),
              ],
            );
          }),
    );
  }
}
