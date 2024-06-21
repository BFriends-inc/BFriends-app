import 'package:flutter/material.dart';
//class for storing the data
class Friend {
  String name;
  String imagePath;
  List<String> languages;
  List<String> hobbies;
  bool favorite;
  bool block;
  Friend(this.name, this.imagePath, this.languages, this.hobbies, this.favorite, this.block);
}