import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:bfriends_app/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:bfriends_app/services/map_controller_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<NavigationService>(create: (_) => NavigationService()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<MapControllerService>(
          create: (_) => MapControllerService(),
        ),
        ChangeNotifierProxyProvider<MapControllerService, MarkerProvider>(
            create: (_) => MarkerProvider(
                Provider.of<MapControllerService>(_, listen: false)),
            update: (_, mapController, markerProvider) {
              if (markerProvider == null) {
                return MarkerProvider(mapController);
              } else {
                markerProvider.fetchMarkers();
                return markerProvider;
              }
            }),
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
