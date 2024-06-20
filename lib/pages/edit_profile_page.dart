import 'package:bfriends_app/pages/homepage.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bfriends_app/widget/profileStats_card.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool changed = false;
  final _formSignupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;
    double width = MediaQuery.of(context).size.width;
    final TextEditingController fullNameController = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          elevation: 5.0,
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          surfaceTintColor: theme.colorScheme.background,
          shadowColor: Colors.black26,
          leading: IconButton(
            onPressed: () {
              //pop
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
          title: Text(
            'Edit Your Profile',
            style: TextStyle(
              fontSize: theme.primaryTextTheme.headlineSmall?.fontSize,
              fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight
            ),
          ),
        ),
      ),
      body: Align(alignment: Alignment.topCenter, child:
      Container(alignment: Alignment.topCenter,
      width: width,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: SingleChildScrollView(keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            height: 150.0,
            width: 150.0,
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/BFriends_logo_full.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
                10.0, 5.0, 5.0, 5.0),
            child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: fullNameController,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        'Please enter your new full name';
                      }
                      else if(value != user?.username) {changed = true;}
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: user?.username,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      helper: const Text('Full Name'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onTertiaryContainer
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onTertiaryContainer
                        ),
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    onSubmitted: (value) {
                      if(value != 'Anything') {changed = true;}
                    },
                    decoration: InputDecoration(
                      labelText: 'Anything.',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      helper: const Text('Status'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onTertiaryContainer
                        ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.onTertiaryContainer
                        ),
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                ],
              ),
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
                        style: theme.textTheme.bodyLarge,
                      ),
                      TextField(
                        onSubmitted: (value) {
                          if(value != 'Anything') {changed = true;}
                        },
                        maxLines: null,
                        maxLength: 200,
                        decoration: InputDecoration(
                          labelText: 'Anything.',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.onTertiaryContainer
                            ),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.colorScheme.onTertiaryContainer
                            ),
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), 
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                StatsCard(
                  title: 'Edit my Preferred Languages',
                    count: user?.listLanguage?.length.toString() ?? '0',
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  StatsCard(
                    title: 'Edit my Interests',
                    count: user?.listInterest?.length.toString() ?? '0',
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formSignupKey.currentState!.validate()) {
                        debugPrint('_formSignupKey.currentState!.validate()');
                      }
                      if(!context.mounted) return;
                      context.pop();
                    },
                    child: const Text('Save changes'),
                  ),
                ),
              )
          ],           
        ),
      ),
      ),
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
