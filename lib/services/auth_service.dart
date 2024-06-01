import 'package:bfriends_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  UserModel? _user; //user information shall be stored here...
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  Future<void> _authStateChanged(User? firebaseUser) async {
    /// Handle changes during Sign-in / Sign-out ///
    if (firebaseUser == null) {
      _user = null;
    } else {
      await _fetchUserData(firebaseUser.uid);
      _user == null
          ? debugPrint('_user is null')
          : debugPrint(
              '${_user?.id} signing in with username: ${_user?.username}');
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      _user = UserModel(
        id: uid,
        joinDate: doc['created_at'].toDate().toString().split(' ')[0],
        username: doc['username'],
        avatarURL: 'abc',
        listLanguage: doc['languages'],
        listInterest: doc['hobbies'],
      );
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //await _fetchUserData(userCredential.user!.uid);
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
            .collection('users')
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
      debugPrint('Error signing up: $e');
    }
    return null;
  }

  Future<void> storeAdditionalUserData(
      User? user, Map<String, dynamic> additionalData) async {
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(additionalData);
      await _fetchUserData(user.uid);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var result = await users.where('email', isEqualTo: email).limit(1).get();
    debugPrint(result.docs.isEmpty.toString());
    return result.docs.isEmpty;
  }

  String? usernameChecker(String username) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!username.contains(regExp)) {
      return "Username can only contain alphanumerics, ., _";
    }
    return null;
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

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
