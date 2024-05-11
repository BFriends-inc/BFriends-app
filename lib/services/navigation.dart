// ignore: dangling_library_doc_comments
////////////////////////////////////////
// According to Flutter.dev using go_router seems more beneficial for our app in the long-term.
// ref: https://docs.flutter.dev/ui/navigation
////////////////////////////////////////
import 'package:bfriends_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//DO: setup routes
final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/home_page',
      pageBuilder: (context, state) => const NoTransitionPage<void>(
        child: HomePage(
          selectedTabs: NavigationTabs.home,
        ),
      ),
    ),
    GoRoute(
        path: '/friends_page',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: HomePage(selectedTabs: NavigationTabs.friends),
            )),
    GoRoute(
        path: '/events_page',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: HomePage(selectedTabs: NavigationTabs.events),
            )),
    GoRoute(
        path: '/profile_page',
        pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: HomePage(selectedTabs: NavigationTabs.profile),
            ))
  ],
  initialLocation: '/home_page',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final currentPath = state.uri.path;
    if (currentPath == '/home' || currentPath == '/') {
      return '/home_page';
    } else if (currentPath == '/friends') {
      return '/friends_page';
    } else if (currentPath == '/events') {
      return '/events_page';
    } else if (currentPath == '/profile') {
      return '/profile_page';
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

  String _currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  void goHome({required NavigationTabs tab}) {
    _router.go('/${tab.name}');
  }
}
