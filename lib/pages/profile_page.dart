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
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    height: 100.0,
                    width: 100.0,
                    child: const ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Placeholder(),
                    ),
                  ),
                  const Flexible(
                    child: Placeholder(
                      //Username display
                      fallbackHeight: 100.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: const Column(children: [
                  Placeholder(
                    //Short Bio...
                    fallbackHeight: 60.0,
                  ),
                  Placeholder(
                    //View preferred language.
                    fallbackHeight: 60.0,
                  ),
                  Placeholder(
                    //View activities type.
                    fallbackHeight: 60.0,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
