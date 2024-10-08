import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/widget/custom_scaffold.dart';
import 'package:provider/provider.dart';

import 'package:bfriends_app/services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formResetPasswordkey = GlobalKey<FormState>();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  key: _formResetPasswordkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      AnimatedTextKit(
                        repeatForever: false,
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '   Reset Password',
                            textStyle: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                            speed: const Duration(milliseconds: 80),
                          ),
                        ],
                      ),
                      // Text(
                      //   'Reset Password',
                      //   style: TextStyle(
                      //     fontSize: 30.0,
                      //     fontWeight: FontWeight.w900,
                      //     color: theme.colorScheme.primary,
                      //   ),
                      // ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _newPassword,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter New Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter New Password',
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
                          suffixIcon: Icon(
                            Icons.lock,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _confirmPassword,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm your Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm New Password',
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
                          suffixIcon: Icon(
                            Icons.lock,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formResetPasswordkey.currentState!
                                .validate()) {
                              if (_newPassword.text != _confirmPassword.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Passwords do not match.'),
                                  ),
                                );
                              } else {
                                int statusCode =
                                    await authService.resetPassword(
                                        _newPassword.text, widget.email);
                                if (statusCode == 200) {
                                  nav.popAuthOnPage(context: context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to reset password'),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15.0)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .blue; // Background color when pressed
                              }
                              return theme.colorScheme
                                  .primary; // Default background color
                            }),
                            foregroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.white; // Text color when pressed
                              }
                              return theme
                                  .colorScheme.onPrimary; // Default text color
                            }),
                          ),
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
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
