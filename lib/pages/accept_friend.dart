import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AcceptFriendPage extends StatefulWidget {
  const AcceptFriendPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AcceptFriendPageState createState() => _AcceptFriendPageState();
}

class _AcceptFriendPageState extends State<AcceptFriendPage> {
  //List<NotificationItem>

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthService>(context);
    final user = auth.user;
    //final requestList = fetchList();
    //final nav = Provider.of<NavigationService>(context);

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
    );
  }
}
