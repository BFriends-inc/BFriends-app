import 'package:bfriends_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bfriends_app/widget/notification.dart';

class NotificationList extends StatelessWidget {
  const NotificationList(
      {super.key,
      required this.notifications,
      required this.onRemoveNotification,
      required this.onAcceptNotification});

  final List<NotificationItem> notifications;
  final void Function(NotificationItem notif, AuthService authService) onRemoveNotification;
  final void Function(NotificationItem notif, AuthService authService) onAcceptNotification;

  @override
  Widget build(BuildContext context) {
    final cardMargin = Theme.of(context).cardTheme.margin ??
        const EdgeInsets.symmetric(horizontal: 16.0);
    final authService = Provider.of<AuthService>(context, listen: false);

    return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(notifications[index]),
            background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                margin: EdgeInsets.symmetric(
                  horizontal: cardMargin.horizontal,
                )),
            onDismissed: (direction) {
              onRemoveNotification(notifications[index], authService);
            },
            child: Notifications(notifications[index], onRemoveNotification, onAcceptNotification)));
  }
}
