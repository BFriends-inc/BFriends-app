import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/widget/welcome_button.dart';
import 'package:bfriends_app/pages/signin_page.dart';
import 'package:bfriends_app/pages/signup_page.dart';
import 'package:bfriends_app/theme/theme.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.secondary, theme.colorScheme.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                height: 200,
                child: Center(
                  child: Image.asset(
                    //cover the whole box with the pic
                    'assets/images/whitelogo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 40.0,
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome to BeFriends!\n',
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          TextSpan(
                            text: '\nA place to connect with people',
                            style: TextStyle(
                              fontSize: 17,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      const Expanded(
                        child: WelcomeButton(
                          buttonText: 'Sign in',
                          tapDestination: 'signin',
                          color: Colors.transparent,
                          textColor: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: WelcomeButton(
                          buttonText: 'Sign up',
                          tapDestination: 'signup',
                          color: Colors.white,
                          textColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
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
