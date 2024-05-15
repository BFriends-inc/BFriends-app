import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: theme.colorScheme.background,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onBackground,
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: theme.primaryTextTheme.headlineMedium?.fontSize,
            fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
