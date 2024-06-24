import 'package:bfriends_app/pages/accept_friend.dart';
import 'package:bfriends_app/pages/add_friend.dart';
import 'package:bfriends_app/pages/edit_profile_page.dart';
import 'package:bfriends_app/pages/email_verification_page.dart';
import 'package:bfriends_app/pages/forget_password_page.dart';
import 'package:bfriends_app/pages/meta_feature_page.dart';
import 'package:bfriends_app/pages/profile_setup_page.dart';
import 'package:bfriends_app/pages/reset_password_page.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> signInRoute = [
  GoRoute(
    path: 'recov_email',
    builder: (context, state) => const ForgetPasswordScreen(),
    routes: [
      GoRoute(
        path: 'verify_email',
        builder: (context, state) {
          final String? email = state.extra as String?;
          return EmailVerificationScreen(email: email ?? '');
        },
        routes: [
          GoRoute(
            path: 'reset_pass',
            builder: (context, state) {
              final String? email = state.extra as String?;
              return ResetPasswordScreen(email: email ?? '');
            },
          ),
        ],
      ),
    ],
  ),
];

List<RouteBase> signUpRoute = [
  GoRoute(
    path: 'set_profile',
    builder: (context, state) {
      final userInfo = state.extra as Map<String, String>?;
      return ProfileSetupScreen(userInfo: userInfo ?? {});
    },
  ),
];

List<RouteBase> profileRoute = [
  GoRoute(
    path: 'meta',
    builder: (context, state) => const MetaFeatPage(),
  ),
  GoRoute(
    path: 'edit_profile',
    builder: (context, state) => const ProfileEditScreen(),
  )
];

List<RouteBase> friendRoute = [
  GoRoute(
    path: 'add_friend',
    builder: (context, state) => const AddFriendPage(),
  ),
  GoRoute(
    path: 'accept_friend',
    builder: (context, state) => const AcceptFriendPage(),
  )
];
