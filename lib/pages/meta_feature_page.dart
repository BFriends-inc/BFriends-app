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
  bool _isPressed = false;
  bool _isAnimatingBack = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    final nav = Provider.of<NavigationService>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          elevation: 5.0,
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          surfaceTintColor: theme.colorScheme.background,
          shadowColor: Colors.black26,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _isPressed = true;
                  });
                },
                onTapUp: (_) async {
                  setState(() {
                    _isPressed = false;
                    _isAnimatingBack = true;
                  });

                  // Wait for the animation to complete
                  await Future.delayed(const Duration(milliseconds: 200));

                  // Perform the sign out and navigation
                  authService.signOut();
                  nav.goWelcome();
                  //idk if this is correct but it works (?)
                  // FIX ME: Right now we return to welcome page using navigation provider function calls.
                  // I tried to find a way to do it without using this method, but it doesn't seem to work.
                  // Some reference I have tried is from Lab 11 & https://stackoverflow.com/questions/74323919/how-can-i-redirect-correctly-to-routes-with-gorouter
                  // Maybe I am doing it wrong(?), but theoretically, we should be able to automatically
                  // return to the welcome_page.dart without having to perform function call.
                },
                onTapCancel: () {
                  setState(() {
                    _isPressed = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..scale(_isPressed || _isAnimatingBack ? 0.98 : 1.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: _isPressed || _isAnimatingBack
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 10.0,
                            ),
                          ],
                  ),
                  child: ListTile(
                    title: Text(
                      'Log out',
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                    splashColor: theme.colorScheme.tertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
