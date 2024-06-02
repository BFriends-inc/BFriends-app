import 'package:bfriends_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MetaFeatPage extends StatefulWidget {
  const MetaFeatPage({super.key});

  @override
  State<MetaFeatPage> createState() => _MetaFeatPageState();
}

class _MetaFeatPageState extends State<MetaFeatPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    double width = MediaQuery.of(context).size.width;

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
            'Settings',
            style: TextStyle(
              fontSize: theme.primaryTextTheme.titleMedium?.fontSize,
              fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: width,
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Placeholder(
                  fallbackHeight: 200.0,
                ),
                const Placeholder(
                  fallbackHeight: 200.0,
                ),
                const Placeholder(
                  fallbackHeight: 200.0,
                ),
                const Divider(),
                SizedBox(
                  height: 40.0,
                  width: width,
                  child: TextButton(
                    onPressed: () {
                      debugPrint('User signing out');
                      authService.signOut();
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return theme
                              .colorScheme.tertiaryContainer; //splash color
                        }
                        return null;
                      }),
                    ),
                    child: Text(
                      'Log out',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
