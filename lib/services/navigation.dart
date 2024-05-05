// ignore: dangling_library_doc_comments
////////////////////////////////////////
// According to Flutter.dev using go_router seems more beneficial for our app in the long-term.
// ref: https://docs.flutter.dev/ui/navigation
//
////////////////////////////////////////
import 'package:bfriends_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//DO: setup routes
final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/homepage',
      pageBuilder: (context, state) => const NoTransitionPage<void>(
        child: HomePage(title: 'Temp Homepage'),
      ),
    ),
  ],
  initialLocation: '/homepage',
  redirect: (context, state) {
    final currentPath = state.uri.path;
    if (currentPath == '/') {
      return '/homepage';
    }
    // No redirection needed for other routes
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);

class NavigationService {
  late final GoRouter _router;

  NavigationService() {
    _router = routerConfig;
  }
}
