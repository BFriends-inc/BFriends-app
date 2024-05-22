import 'package:flutter/material.dart';

class Hobbies extends StatefulWidget {
  final List<String> items;
  const Hobbies({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => _hobbiesSelect();
}

// ignore: camel_case_types
class _hobbiesSelect extends State<Hobbies> {
  // this variable holds the selected items
  final List<String> _selectedHobbies = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedHobbies.add(itemValue);
      } else {
        _selectedHobbies.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedHobbies);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Hobbies'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedHobbies.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
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
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
