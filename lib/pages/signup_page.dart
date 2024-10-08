import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/widget/custom_scaffold.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context, listen: false);
    //get screen width + height
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordConfirmationController =
        TextEditingController();

    bool emailExists = false;

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
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      AnimatedTextKit(
                        repeatForever: false,
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '   Let\'s Get Started!',
                            textStyle: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                            speed: const Duration(milliseconds: 80),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      // full name
                      TextFormField(
                        controller: fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Full Name'),
                          hintText: 'Enter Full Name',
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
                      // email
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          } else if (!emailExists) {
                            return 'Email is already taken. Please try another one.';
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
                      // password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        autocorrect: false,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return authService.passwordChecker(value);
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
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
                      // confirm password
                      TextFormField(
                        controller: passwordConfirmationController,
                        obscureText: true,
                        autocorrect: false,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value != passwordController.text) {
                            return 'Password does not match. Please try again.';
                          }
                          return authService
                              .passwordChecker(passwordController.text);
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your Password',
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
                      // i agree to the processing
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                          const Flexible(
                            child: Text(
                              'I agree to share my personal data to process information.',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
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
                                borderRadius: BorderRadius.circular(
                                    17.0), // Adjust the border radius as needed
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity,
                                  50.0), // Width set to match parent, height set to 120.0
                            ),
                          ),
                          onPressed: () async {
                            emailExists = await authService
                                .checkEmailExists(emailController.text.trim());
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              Map<String, String> userInfo = {
                                'fullName': fullNameController.text,
                                'email': emailController.text
                                    .trim(), //trim email to avoid white spaces.
                                'password': passwordController.text,
                              };
                              // Navigate to ProfileSetupScreen
                              nav.pushAuthOnPage(
                                  context: context,
                                  destination: 'set_profile',
                                  extra: userInfo);
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please agree to the processing of personal data'),
                                ),
                              );
                            }
                          },
                          child: const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // sign up divider
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.7,
                      //         color: theme.colorScheme.outlineVariant
                      //             .withOpacity(0.5),
                      //       ),
                      //     ),
                      //     const Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         vertical: 0,
                      //         horizontal: 10,
                      //       ),
                      //       child: Text(
                      //         'Sign up with',
                      //         style: TextStyle(
                      //           color: Colors.black45,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.7,
                      //         color: theme.colorScheme.outlineVariant
                      //             .withOpacity(0.5),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 25.0,
                      // ),
                      // // sign up social media logo
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Logo(Logos.google),
                      //     Logo(Logos.apple),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              nav.popAuthOnPage(context: context);
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
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
