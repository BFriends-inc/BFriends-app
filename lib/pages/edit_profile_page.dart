import 'package:bfriends_app/pages/homepage.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bfriends_app/pages/profile_setup_page.dart';
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
  List<String> _selectedItems = [];
  List<String> _selectedHobbies = [];

  void _languageSelect() async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MultiSelect(
          items: [
            'English',
            'Chinese',
            'Indonesian',
            'Thai',
            'Filipino',
            'Spanish',
            'Hindi',
            'Arabic'
          ],
          title: 'Select Your Preferred Languages',
        );
      },
    );

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  void _hobbySelect() async {
    final List<String>? resultsHobby = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const MultiSelect(
          items: [
            'Basketball',
            'Swimming',
            'Cycling',
            'Drawing',
            'Running',
            'Soccer',
            'Piano',
            'Guitar',
            'Dancing',
            'Singing',
            'Reading',
            'Coding',
          ],
          title: 'Select Your Preferred Hobbies',
        );
      },
    );

    if (resultsHobby != null) {
      setState(() {
        _selectedHobbies = resultsHobby;
      });
    }
  }

  void _editProfile() async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;
    await authService.storeAdditionalUserData(user, {
      'username': usernameController.text,
      'dateOfBirth': _selectedDate?.toIso8601String(),
      'gender': _selectedGender,
      'languages': _selectedItems,
      'hobbies': _selectedHobbies
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;
    double width = MediaQuery.of(context).size.width;
    final TextEditingController fullNameController = TextEditingController();
    if(_selectedItems.isEmpty){
      for (int i = 0; i < user!.listLanguage!.length;){
        _selectedItems.add(user.listLanguage![i]);
        i+=1;
      }
    }
    if(_selectedHobbies.isEmpty){
      for (int i = 0; i < user!.listInterest!.length;){
        _selectedHobbies.add(user.listInterest![i]);
        i+=1;
      }
    }

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
              changed ? showDialog(
                          context: context, 
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Leave without saving?'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('There are some unsaved changes made.'),
                                    Text('Confirm leaving page without saving?')
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    context.pop();
                                  },
                                  child: const Text('Leave')
                                ),
                                TextButton(
                                  onPressed: () {Navigator.pop(context); },
                                  child: const Text('Cancel'))
                              ],
                            );
                          }) 
              : context.pop();
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
                  TextField(
                    controller: fullNameController,
                    onChanged: (value) {
                      if(value != user?.username) {changed = true;}
                    },
                    // validator: (value) {
                    //   if(value == null || value.isEmpty) {
                    //     return 'Please enter your new full name';
                    //   }
                    //   else if(value != user?.username) {changed = true;}
                    //   return null;
                    // },
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
                    onChanged: (value) {
                      debugPrint(value);
                      if(value != 'Anything') {debugPrint('changed'); changed = true;}
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
                        onChanged: (value) {
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
                // StatsCard(
                //   title: 'Edit my Preferred Languages',
                //     count: user?.listLanguage?.length.toString() ?? '0',
                //   ),
                //   const SizedBox(
                //     height: 20.0,
                //   ),
                //   StatsCard(
                //     title: 'Edit my Interests',
                //     count: user?.listInterest?.length.toString() ?? '0',
                //   ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.tertiaryContainer,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                onPressed: _languageSelect,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Edit Your Preferred Languages',
                                        style: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      const Icon(Icons.language),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7.5),
                            Wrap(
                              children: _selectedItems
                                  .map((e) => Chip(
                                        label: Text(e),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.tertiaryContainer,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                onPressed: _hobbySelect,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Edit Your Preferred Hobbies',
                                        style: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      const Icon(Icons.sports_tennis),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7.5),
                            Wrap(
                              children: _selectedHobbies
                                  .map((e) => Chip(
                                        label: Text(e),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                        changed ? showDialog(
                          context: context, 
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Saved Changes?'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('There are some changes made.'),
                                    Text('Confirm save changes and update profile?')
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: (){
                                    _editProfile;
                                    Navigator.of(context).pop();
                                    context.pop();
                                  },
                                  child: const Text('Save')
                                ),
                                TextButton(
                                  onPressed: () {Navigator.pop(context); },
                                  child: const Text('Cancel'))
                              ],
                            );
                          })
                        : context.pop();
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
