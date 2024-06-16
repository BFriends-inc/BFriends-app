import 'package:flutter/material.dart';

import 'package:bfriends_app/models/notification.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key, required this.notifications, required this.onRemoveNotification});

  final List<NotificationItem> notifications;
  final void Function(NotificationItem notif) onRemoveNotification;

  @override
  Widget build(BuildContext context) {
    final cardMargin = Theme.of(context).cardTheme.margin ?? const EdgeInsets.symmetric(horizontal: 16.0);

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(notifications[index]), 
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: cardMargin.horizontal,
          )
        ),
        onDismissed: (direction) {
          onRemoveNotification(notifications[index]);
        },
        child: Notifications(
          notifications[index]
        )
      )
    );
  }
}
