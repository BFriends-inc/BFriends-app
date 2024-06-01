import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/widget/profileStats_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              //go to meta functions
            },
            icon: const Icon(Icons.circle),
          ),
        ],
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
                              child: Image.asset(
                                'assets/images/BFriends_logo_full.png',
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
                                    user.username,
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'Something',
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
                                  'About me mvlajkljdklajd',
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
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          StatsCard(
                            title: 'My Preferred Languages',
                            count: user.listLanguage.length.toString(),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          StatsCard(
                            title: 'My Interests',
                            count: user.listInterest.length.toString(),
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
