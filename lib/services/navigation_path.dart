import 'package:bfriends_app/pages/email_verification_page.dart';
import 'package:bfriends_app/pages/forget_password_page.dart';
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
        builder: (context, state) => const EmailVerificationScreen(),
        routes: [
          GoRoute(
            path: 'reset_pass',
            builder: (context, state) => const ResetPasswordScreen(),
          ),
        ],
      ),
    ],
  ),
];

List<RouteBase> signUpRoute = [
  GoRoute(
    path: 'set_profile',
    builder: (context, state) => const ProfileSetupScreen(),
  ),
];
