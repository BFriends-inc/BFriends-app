import 'package:bfriends_app/widget/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  UserModel({
    this.firebaseUser,
    required this.id,
    required this.email,
    required this.joinDate,
    required this.username,
    required this.avatarURL,
    required this.listLanguage,
    required this.listInterest,
    required this.friends,
    required this.requesting,
    required this.requests,
    required this.favorite,
    required this.block,
  });

  User? firebaseUser;
  String? id;
  String? email;
  Object? joinDate;
  String? username;
  final String? avatarURL;
  final List<dynamic>? listLanguage, listInterest;
  final List<dynamic>? friends, requests, requesting, favorite, block;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    debugPrint('A user found with doc id: ${doc.id}');
    return UserModel(
      //firebaseUser: firebaseUser,
      id: doc.id,
      email: data['email'],
      joinDate: data['created_at'].toDate().toString().split(' ')[0],
      username: data['username'],
      avatarURL: data['avatarURL'],
      listLanguage: data['languages'],
      listInterest: data['hobbies'],
      friends: data['friends'],
      requests: data['requests'],
      requesting: data['requesting'],
      favorite: data['favorite'],
      block: data['block'],
    );
  }
}