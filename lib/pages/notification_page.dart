import 'package:bfriends_app/services/map_controller_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/models/notification.dart';
import 'package:bfriends_app/list/notification_list.dart';
import 'package:bfriends_app/services/navigation.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<NotificationItem> _notifications = 
  [
    NotificationItem(type: 'join'), 
    NotificationItem(type: 'req'), 
    NotificationItem(type: 'create')
  ];
  
  void _removeNotification(NotificationItem notif) {
    final notifIndex = _notifications.indexOf(notif);
    setState(() {
      _notifications.remove(notif);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: (notif.type == 'req') ? const Text('You have a new friend!') : const Text('Notification removed.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              _notifications.insert(notifIndex, notif);
            });
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mapControllerService = Provider.of<MapControllerService>(context);

    Widget notifList = const Center(
      child: Text('No new notifications!'),
    );

    if(_notifications.isNotEmpty){
      notifList = NotificationList(
        notifications: _notifications,
        onRemoveNotification: _removeNotification,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          elevation: 5.0,
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          surfaceTintColor: theme.colorScheme.background,
          shadowColor: Colors.black26, //Need shadow color
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
              fontSize: theme.primaryTextTheme.headlineSmall?.fontSize,
              fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight,
            ),
          ),
        ),
        // actions: <Widget>[
        //    IconButton(
        //     icon: Icon(
        //       Icons.notifications_outlined,
        //       color: Color.fromARGB(255, 0, 0, 0),
        //       semanticLabel: 'Notifications',
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(child: notifList,)
        ]
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
