import 'package:bfriends_app/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/services/navigation.dart';

class GoogleAuth {
  // Google Sign In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out any previously signed-in user to prompt account selection
      await googleSignIn.signOut();

      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();

      if (gUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the widget is still mounted before navigating
      if (userCredential.user != null && context.mounted) {
        final nav = Provider.of<NavigationService>(context, listen: false);
        nav.goHome(tab: NavigationTabs.home);

        // Get the GoRouter instance from the context and navigate
        final router = GoRouter.of(context);
        router.go('/home_page');
      }
    } catch (e) {
      // Handle sign-in errors here if necessary
      print('Error during Google sign-in: $e');
    }
  }
}
