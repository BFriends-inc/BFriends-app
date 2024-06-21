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
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
