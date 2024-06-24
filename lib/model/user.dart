import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  UserModel({
    required this.firebaseUser,
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
  });

  User? firebaseUser;
  String? id;
  String? email;
  Object? joinDate;
  String? username;
  final String? avatarURL;
  final List<dynamic>? listLanguage, listInterest;
  final List<dynamic>? friends, requests, requesting;
}
