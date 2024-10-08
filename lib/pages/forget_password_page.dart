import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/widget/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/services/auth_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const ForgetPasswordScreen({Key? key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formForgetPasswordKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formForgetPasswordKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedTextKit(
                        repeatForever: false,
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '   Forgot Your Password?',
                            textStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                            speed: const Duration(milliseconds: 80),
                          )
                        ],
                      ),
                      Text(
                        'Enter the email associated with your account',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme
                                  .tertiaryContainer, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme
                                  .tertiaryContainer, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formForgetPasswordKey.currentState!
                                .validate()) {
                              if (_emailController.text.isEmpty) {
                                // Show snackbar if email is empty
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in Email'),
                                  ),
                                );
                              } else {
                                int isSent =
                                    await authService.sendVerificationCode(
                                        _emailController.text);
                                if (isSent == 200) {
                                  // Navigate to EmailVerificationScreen
                                  nav.pushAuthOnPage(
                                      context: context,
                                      destination: 'verify_email',
                                      extra: _emailController.text);
                                } else if (isSent == 404) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Email not registered'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to send verification code'),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return theme.colorScheme.secondary;
                                } else if (states
                                    .contains(MaterialState.pressed)) {
                                  return theme.colorScheme.tertiary;
                                }
                                return theme.colorScheme.primary;
                              },
                            ),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                fontSize: 15.0,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15.0),
                            ),
                          ),
                          child: const Text(
                            'Recover Password',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
