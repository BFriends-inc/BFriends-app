import 'dart:io';
import 'package:bfriends_app/model/friend.dart';
import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/pages/reset_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class AuthService extends ChangeNotifier {
  UserModel? _user; //user information shall be stored here...
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final Uuid uuid = const Uuid();

  UserModel? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  Future<void> _authStateChanged(User? firebaseUser) async {
    debugPrint(firebaseUser.toString());
    /// Handle changes during Sign-in / Sign-out ///
    if (firebaseUser == null) {
      _user = null;
    } else {
      await fetchUserData(firebaseUser.uid, firebaseUser);
      _user == null
          ? debugPrint('_user is null')
          : debugPrint(
              '${_user?.id} signing in with username: ${_user?.username}');
    }
    notifyListeners();
  }

  Future<void> fetchUserData(String uid, User firebaseUser) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      debugPrint('Fetching user data for $uid');
      debugPrint('Data: ${doc.data()}');
      if (doc['email'] != null) {
        //can only fetch data if email is not empty.
        return UserModel(
          firebaseUser: firebaseUser,
          id: uid,
          email: doc['email'],
          joinDate: doc['created_at'].toDate().toString().split(' ')[0],
          username: doc['username'],
          avatarURL: doc['avatarURL'],
          listLanguage: doc['languages'],
          listInterest: doc['hobbies'],
          friends: doc['friends'],
          requests: doc['requests'],
          requesting: doc['requesting'],
          favorite: doc['favorite'],
          block: doc['block'],
        );
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
    return null;
  }

  Future<List<UserModel>> searchUsers(String query, String? username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .where('username', isNotEqualTo: username)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  Future<void> sendFriendRequest(
      String currentUserId, String friendUserId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUserId).get();
    DocumentSnapshot friendDoc =
        await _firestore.collection('users').doc(friendUserId).get();
    List<dynamic>? userRequesting = userDoc['requesting'];
    List<dynamic>? friendRequests = friendDoc['requests'];
    userRequesting?.add(friendUserId);
    friendRequests?.add(currentUserId);
    await _firestore.collection('users').doc(currentUserId).update({
      'requesting': userRequesting,
    });
    await _firestore.collection('users').doc(friendUserId).update({
      'requests': friendRequests,
    });
    fetchUserData(_user!.id.toString(), _user!.firebaseUser!);
  }

  Future<void> removeFriendRequest(
      String currentUserId, String friendUserId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUserId).get();
    DocumentSnapshot friendDoc =
        await _firestore.collection('users').doc(friendUserId).get();
    List<dynamic>? userRequests = userDoc['requests'];
    List<dynamic>? friendRequesting = friendDoc['requesting'];
    if (userRequests!.isNotEmpty) userRequests.remove(friendUserId);
    if (friendRequesting!.isNotEmpty) friendRequesting.remove(currentUserId);
    await _firestore.collection('users').doc(currentUserId).update({
      'requests': userRequests,
    });
    await _firestore.collection('users').doc(friendUserId).update({
      'requesting': friendRequesting,
    });
    await fetchUserData(_user!.id.toString(), _user!.firebaseUser!);
  }

  Future<void> acceptFriend(String currentUserId, String friendUserId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUserId).get();
    DocumentSnapshot friendDoc =
        await _firestore.collection('users').doc(friendUserId).get();
    List<dynamic>? userRequests = userDoc['requests'];
    List<dynamic>? userFriends = userDoc['friends'];
    List<dynamic>? friendRequesting = friendDoc['requesting'];
    List<dynamic>? friendFriends = friendDoc['friends'];
    if (userRequests!.isNotEmpty) userRequests.remove(friendUserId);
    userFriends?.add(friendUserId);
    if (friendRequesting!.isNotEmpty) friendRequesting.remove(currentUserId);
    friendFriends?.add(currentUserId);
    await _firestore.collection('users').doc(currentUserId).update({
      'requests': userRequests,
      'friends': userFriends,
    });
    await _firestore.collection('users').doc(friendUserId).update({
      'requesting': friendRequesting,
      'friends': friendFriends,
    });

    // Create a unique relationship ID
    String relationshipId = uuid.v4();

    // Create a new relationship document
    Map<String, dynamic> relationshipData = {
      'relationshipId': relationshipId,
      'participants': [currentUserId, friendUserId],
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('relationships').doc(relationshipId).set(relationshipData);

    // Add relationshipId to each user's document
    await _firestore.collection('users').doc(currentUserId).update({
      'relationshipIds': FieldValue.arrayUnion([relationshipId]),
    });

    await _firestore.collection('users').doc(friendUserId).update({
      'relationshipIds': FieldValue.arrayUnion([relationshipId]),
    });

    await fetchUserData(_user!.id.toString(), _user!.firebaseUser!);
  }

  Future<Friend> fetchFriend(String friendUserId) async {
    DocumentSnapshot friendDoc =
        await _firestore.collection('users').doc(friendUserId).get();
    // if(friendDoc == null) return null;
    return Friend(
        id: friendUserId,
        username: friendDoc['username'],
        imagePath: friendDoc['avatarURL'].toString(),
        languages: friendDoc['languages'],
        interests: friendDoc['hobbies'],
        favorite: _user!.favorite!.contains(friendUserId),
        block: _user!.block!.contains(friendUserId));
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
    String? avatarURL;

    if (user != null) {
      if (additionalData['userImage'] != null) {
        final storageRef =
            _storage.ref().child('userImages').child('${user.uid}.jpg');
        await storageRef.putFile(File(additionalData['userImage'].path));
        avatarURL = await storageRef.getDownloadURL();
        additionalData['avatarURL'] = avatarURL;
        additionalData.remove('userImage');
      }
      await _firestore.collection('users').doc(user.uid).update(additionalData);
      //await _firestore.collection('users').doc(user.uid).update(additionalData);
      await fetchUserData(user.uid, user);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var result = await users.where('email', isEqualTo: email).limit(1).get();

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
    debugPrint("signing out from ${_user!.email}");
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<int> sendVerificationCode(String email) async {
    final url =
        Uri.parse('https://asia-east1-bfriend-dev.cloudfunctions.net/sendCode');

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

      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('Verification code sent to $email');
        return 200;
      } else if (response.statusCode == 404) {
        debugPrint('Email not found');
        return 404;
      } else {
        throw Exception('Failed to send verification code');
      }
    } catch (e) {
      debugPrint('Error sending verification code: $e');
      return 500;
    }
  }

  Future<int> verifyCode(String verificationCode, email) async {
    final url = Uri.parse(
        'https://asia-east1-bfriend-dev.cloudfunctions.net/verifyCode');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'code': verificationCode,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Verification successful');
      return 200;
    } else {
      return 500;
    }
  }

  Future<int> resetPassword(String password, String email) async {
    final url = Uri.parse(
        'https://asia-east1-bfriend-dev.cloudfunctions.net/resetPassword'); // Corrected endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Password reset successful');
        return 200;
      } else if (response.statusCode == 404) {
        debugPrint('Failed to reset password: ${response.body}');
        return 404;
      } else {
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      debugPrint('Error resetting password: $e');
      return 500;
    }
  }

  Future<void> updateUserFcmToken(String userId, String token) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }
}
