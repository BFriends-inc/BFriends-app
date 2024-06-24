import 'dart:async';

import 'package:bfriends_app/pages/edit_profile_page.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:bfriends_app/widget/bar_button.dart';
import 'package:bfriends_app/widget/profileStats_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final nav = Provider.of<NavigationService>(context, listen: false);
    final user = authService.user;
    double width = MediaQuery.of(context).size.width;
    debugPrint(user?.username ?? 'NULL');

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: theme.colorScheme.primary,
          actions: [
            IconButton(
              onPressed: () {
                //go to meta functions
                nav.pushPageOnProfile(context: context, destination: 'meta');
                //setState(() {});
              },
              icon: Icon(
                Icons.menu_rounded,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        //user's profiles displayed here.
        child: user != null 
            ? Container(
                width: width,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            height: 100.0,
                            width: 100.0,
                            child: ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                user.avatarURL.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              //username display
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 5.0, 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username ?? '',
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    user.status ?? '',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                        child: Column(children: [
                          Container(
                            //BIO
                            width: double.infinity,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About Me',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  user.aboutMe ?? '',
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Joined Since',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  user.joinDate.toString(),
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    //collection of buttons
                                    // BarButton(
                                    //   color: theme.colorScheme.primaryContainer,
                                    //   onColor:
                                    //       theme.colorScheme.onPrimaryContainer,
                                    //   height: 30.0,
                                    //   icon: Icons.edit,
                                    //   text: 'Edit My Profile',
                                    //   tapDestination: 'edit_profile',
                                    // )
                                    GestureDetector(
                                      onTap: () {
                                        debugPrint("Bar button pressed.");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileEditScreen()),
                                        ).then((_) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            setState(() {
                                              debugPrint(
                                                  "State updated with new message after delay");
                                            });
                                          });
                                        });
                                        // final nav =
                                        //     Provider.of<NavigationService>(
                                        //         context,
                                        //         listen: false);
                                        // nav.pushAuthOnPage(
                                        //     context: context,
                                        //     destination: 'edit_profile');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: theme.colorScheme.primary,
                                        ),
                                        height: 30,
                                        width: ((theme.textTheme.bodySmall!
                                                    .fontSize! /
                                                theme.textTheme.bodySmall!
                                                    .height!) *
                                            'Edit My Profile'.length),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 20.0,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              'Edit My Profile',
                                              style: TextStyle(
                                                  color: theme
                                                      .colorScheme.onPrimary,
                                                  fontStyle: theme.textTheme
                                                      .bodySmall!.fontStyle,
                                                  fontSize: theme.textTheme
                                                      .bodySmall!.fontSize),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          StatsCard(
                            title: 'My Preferred Languages',
                            count: user.listLanguage!.length.toString(),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          StatsCard(
                            title: 'My Interests',
                            count: user.listInterest!.length.toString(),
                          ),
                       ]),
                      ),
                     ],
                   ),
                ),
              )
            : const Center(child: Text('Fetching user data...')),
      ),
    );
  }
}
