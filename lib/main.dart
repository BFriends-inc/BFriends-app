import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bfriends_app/services/navigation.dart';
import 'package:bfriends_app/theme/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BFriends app',
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: routerConfig,
      restorationScopeId: 'app',
    );
  }
}
