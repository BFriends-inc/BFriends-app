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
    required this.status,
    required this.aboutMe
  });

  User? firebaseUser;
  String? id;
  String? email;
  Object? joinDate;
  String? username;
  String? avatarURL;
  final List<dynamic>? listLanguage;
  final List<dynamic>? listInterest;
  String? status;
  String? aboutMe;
}
