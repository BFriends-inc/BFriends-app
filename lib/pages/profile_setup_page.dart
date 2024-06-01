import 'package:bfriends_app/pages/homepage.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  final Map<String, String> userInfo;
  const ProfileSetupScreen({super.key, required this.userInfo});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formProfileSetupKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  List<String> _selectedItems = [];
  List<String> _selectedHobbies = [];

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

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

  void _submitForm() {
    if (_formProfileSetupKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
      } else if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your date of birth')),
        );
      } else if (_selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one language')),
        );
      } else if (_selectedHobbies.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one hobby')),
        );
      } else {
        // Proceed with form submission logic here
        _registerUser();
      }
    }
  }

  void _registerUser() async {
    widget.userInfo['email'] != null
        ? debugPrint(widget.userInfo['email'])
        : debugPrint('email is null');
    final authService = Provider.of<AuthService>(context, listen: false);
    User? user = await authService.signUp(
        widget.userInfo['email']!, widget.userInfo['password']!);
    await authService.storeAdditionalUserData(user, {
      'username': usernameController.text,
      'dateOfBirth': _selectedDate?.toIso8601String(),
      'gender': _selectedGender,
      'languages': _selectedItems,
      'hobbies': _selectedHobbies
    });
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goHome(tab: NavigationTabs.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        elevation: 0,
        title: Text(
          'SETUP YOUR PROFILE',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSecondary,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSecondary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formProfileSetupKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                const CircleAvatar(
                  radius: 80,
                ),
                const SizedBox(height: 33.0),
                TextFormField(
                  controller: usernameController,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return authService.usernameChecker(usernameController.text);
                  },
                  decoration: InputDecoration(
                    label: const Text('Username'),
                    hintText: 'Input Username',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiaryContainer,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.tertiaryContainer,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.9),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.colorScheme.tertiaryContainer,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: <String>['Female', 'Male', 'Rather not say']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.9),
                        child: GestureDetector(
                          onTap: () => _presentDatePicker(),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.tertiaryContainer,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? 'Date of Birth'
                                      : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                                ),
                                IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: theme.colorScheme.tertiary,
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
                const SizedBox(height: 15.0),
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
                                        'Select Your Preferred Languages',
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
                                        'Select Your Preferred Hobbies',
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Save and Enter'),
          ),
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final String title;

  const MultiSelect({super.key, required this.items, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) =>
                        _itemChange(item, isChecked ?? false),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save and Enter'),
        ),
      ],
    );
  }
}
