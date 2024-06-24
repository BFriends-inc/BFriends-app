import 'package:bfriends_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationItem{
  NotificationItem({required this.username, required this.pfp, required this.id});

  final String username;
  final String pfp;
  final String id;
  
}

class Notifications extends StatelessWidget {
  const Notifications(this.notifitem, this.onRemoveNotification, this.onAcceptNotification, {super.key});

  final NotificationItem notifitem;
  final void Function(NotificationItem notif, AuthService authService) onRemoveNotification;
  final void Function(NotificationItem notif, AuthService authService) onAcceptNotification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(5.0),
              height: 100.0,
              width: 100.0,
             child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  notifitem.pfp,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          Text('You have a new friend request from ${notifitem.username}',
                            style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Accept'),
                                onPressed: (){onAcceptNotification(notifitem, authService);},
                              ),
                              const SizedBox(width: 30,),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text('Reject'),
                                onPressed: (){onRemoveNotification(notifitem, authService);},
                              ),
                            ]
                          )
                        ],
                      )
                    ),
                ],),
      ),);
  }
}
