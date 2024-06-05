import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
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
    final nav = Provider.of<NavigationService>(context);
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
                      // FIX ME: Right now we return to welcome page using navigation provider function calls.
                      // I tried to find a way to do it without using this method, but it doesn't seem to work.
                      // Some reference I have tried is from Lab 11 & https://stackoverflow.com/questions/74323919/how-can-i-redirect-correctly-to-routes-with-gorouter
                      // Maybe I am doing it wrong(?), but theoretically, we should be able to automatically
                      // return to the welcome_page.dart without having to perform function call.
                      debugPrint('User signing out');
                      authService.signOut();
                      nav.goWelcome();
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
