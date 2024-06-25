import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//class for storing the data
class Friend {
  String id;
  String username;
  String imagePath;
  List<dynamic>? languages;
  List<dynamic>? interests;
  bool favorite;
  bool block;
  String? aboutMe;
  String? status;
  Friend(
      {required this.id,
      required this.username,
      required this.imagePath,
      this.languages,
      this.interests,
      required this.favorite,
      required this.block,
      this.aboutMe,
      this.status});

  factory Friend.fromDocument(DocumentSnapshot doc) {
    return Friend(
      id: doc.id,
      username: doc['username'],
      imagePath: doc['imagePath'],
      languages: List<String>.from(doc['languages']),
      interests: List<String>.from(doc['interests']),
      favorite: doc['favorite'],
      block: doc['block'],
      status: doc['status'],
      aboutMe: doc['aboutMe'],
    );
  }
}
