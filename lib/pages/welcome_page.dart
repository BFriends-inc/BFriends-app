import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/widget/welcome_button.dart';

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
        child: Column(
          children: [
            const SizedBox(height: 200),
            SizedBox(
              height: 200,
              child: Center(
                child: Image.asset(
                  'assets/images/whitelogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: Column(
                  children: [
                    AnimatedTextKit(
                      repeatForever: false,
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          '   Welcome to BeFriends!',
                          textStyle: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                      ],
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\nA place to connect with people',
                            style: TextStyle(
                              fontSize: 15,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(), // Pushes the buttons to the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40, // height
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        tapDestination: 'signin',
                        color: Colors.transparent,
                        textColor: Colors.white,
                        hoverColor: Colors.transparent,
                        pressedColor: Colors.grey, // Color when pressed
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // button spacing
                  Expanded(
                    child: SizedBox(
                      height: 50, //
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        tapDestination: 'signup',
                        color: Colors.white,
                        textColor: theme.colorScheme.primary,
                        hoverColor: const Color.fromARGB(255, 198, 194, 199),
                        pressedColor: Colors.grey, // Color when pressed
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
