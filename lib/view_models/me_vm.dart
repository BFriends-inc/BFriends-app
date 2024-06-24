// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:bfriends_app/models/user.dart';
// import 'package:bfriends_app/repositories/user_repo.dart';

// class MeViewModel with ChangeNotifier {
//   final UserRepository _userRepository;
//   late StreamSubscription<User?> _meSubscription;

//   final StreamController<User> _meStreamController = StreamController<User>();
//   Stream<User> get meStream => _meStreamController.stream;

//   late String _myId;
//   String get myId => _myId;
//   User? _me;
//   User? get me => _me;

//   bool _lastIsModerator = false;
//   bool _isModeratorStatusChanged = false;

//   bool get isModeratorStatusChanged => _isModeratorStatusChanged;

//   MeViewModel(String userId, {UserRepository? userRepository})
//       : _userRepository = userRepository ?? UserRepository() {
//     _myId = userId;
//     _meSubscription = _userRepository.streamUser(userId).listen((me) {
//       if (me == null) {
//         return;
//       }

//       _meStreamController.add(me);
//       if (_me != null) {
//         // Skip the first time when `_me` is null
//         _isModeratorStatusChanged = _lastIsModerator != me.isModerator;
//         _lastIsModerator = me.isModerator;
//       }
//       _me = me;

//       notifyListeners();
//     });
//   }

//   @override
//   void dispose() {
//     _meSubscription.cancel();
//     _meStreamController.close();
//     super.dispose();
//   }

//   Future<void> addMe(User me) async {
//     await _userRepository.createOrUpdateUser(me);
//   }
// }
