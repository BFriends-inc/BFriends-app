import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:bfriends_app/theme/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<NavigationService>(create: (_) => NavigationService()),
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
