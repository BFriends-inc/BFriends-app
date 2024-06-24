import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationItem{
  NotificationItem({required this.type});

  final String type;
}

class Notifications extends StatelessWidget {
  const Notifications(this.notifitem, {super.key});

  final NotificationItem notifitem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.circle, size: 70),
            const SizedBox(width: 10,),
           Expanded(child: 
              Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(notifitem.type == 'join') Text('You have joined an event')
                else if(notifitem.type == 'create') Text('You have created an event')
                else if(notifitem.type == 'req') 
                  Text('You have a friend request'),
                if(notifitem.type == 'req') const SizedBox(height: 10,)
                else const SizedBox(height: 30,),
                if(notifitem.type == 'req') 
                  Row(children: [
                    Icon(Icons.add),
                    const SizedBox(width: 10,),
                    Icon(Icons.cancel),
                  ],)
            ],)
        ),],
        )
      )
    );
  }
}
