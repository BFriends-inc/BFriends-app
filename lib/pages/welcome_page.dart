import 'package:flutter/material.dart';
import 'package:bfriends_app/widget/welcome_button.dart';
import 'package:bfriends_app/pages/signin_page.dart';
import 'package:bfriends_app/pages/signup_page.dart';
import 'package:bfriends_app/theme/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            //cover the whole page with the pic
            'assets/images/bg1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 270),
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
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome to BeFriends!\n',
                              style: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '\nA place to connect with people',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
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
                            onTap: SignInScreen(),
                            color: Colors.transparent,
                            textColor: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: WelcomeButton(
                            buttonText: 'Sign up',
                            onTap: const SignUpScreen(),
                            color: Colors.white,
                            textColor: lightColorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
