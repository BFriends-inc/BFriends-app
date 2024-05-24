import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'dart:convert'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
      }
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        Map<String, dynamic> userData = {
          'email': email,
          'created_at': FieldValue.serverTimestamp(),
        };
        await _firestore
            .collection('email_collection')
            .doc(userCredential.user!.uid)
            .set(userData);
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> storeAdditionalUserData(
      User? user, Map<String, dynamic> additionalData) async {
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(additionalData);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('email_collection');
    var result = await users.where('email', isEqualTo: email).limit(1).get();

    return result.docs.isEmpty;
  }

  String? passwordChecker(String password) {
    //custom function check password strength & formats
    RegExp regExp = RegExp(r'^[a-zA-Z0-9!-/:-@]+$');
    if (password.length < 8) return "Password too short. Minimum 8 characters.";
    if (!password.contains(regExp)) {
      return "Password contain invalid characters.";
    }

    return null;
  }

  Future<bool> sendVerificationCode(String email) async {
    final url = Uri.parse('http://10.0.2.2:3000/send-code');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Verification code sent to $email');
        return true;
      } else {
        throw Exception('Failed to send verification code. Status code: ${response.statusCode}');
      }
    } catch (e) {
        debugPrint('Error sending verification code: $e');
        return false;
    }
  }
}
