import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        child: Container(
          width: width,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
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
                            'Date',
                            style: theme.textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      //LANGUAGE
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'My Preferred Languages',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '999',
                                    style: theme.textTheme.bodySmall,
                                    textAlign: TextAlign.right,
                                  ),
                                  IconButton(
                                    iconSize:
                                        theme.textTheme.bodyMedium!.fontSize,
                                    style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    onPressed: () {
                                      debugPrint('view languages pressed.');
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      //ACTIVITY
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'My Interests',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '999',
                                    style: theme.textTheme.bodySmall,
                                    textAlign: TextAlign.right,
                                  ),
                                  IconButton(
                                    iconSize:
                                        theme.textTheme.bodyMedium!.fontSize,
                                    style: const ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    onPressed: () {
                                      debugPrint('view activities pressed.');
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
