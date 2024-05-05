import 'package:bfriends_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/pages/homepage.dart';
import 'package:bfriends_app/services/navigation.dart';

final themeData = lightMode;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BFriends app',
      theme: themeData,
      routerConfig: routerConfig,
      restorationScopeId: 'app',
    );
  }
}
