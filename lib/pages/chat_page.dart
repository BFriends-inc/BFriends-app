// import 'package:flutter/material.dart';
// import 'package:bfriends_app/services/authentication.dart';
// import 'package:bfriends_app/services/push_messaging.dart';
// import 'package:bfriends_app/view_models/me_vm.dart';
// import 'package:bfriends_app/list/message_list.dart';
// import 'package:bfriends_app/widgets/new_message_bar.dart';
// import 'package:provider/provider.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   late final PushMessagingService _pushMessagingService;

//   @override
//   void initState() {
//     super.initState();

//     final myId = Provider.of<MeViewModel>(context, listen: false).myId;
//     _pushMessagingService =
//         Provider.of<PushMessagingService>(context, listen: false);
//     // Initialize `_pushMessagingService` without awaiting, so that the `build` method can run
//     _pushMessagingService.initialize(
//       userId: myId,
//       topics: ['chat'],
//     ).catchError((e) {
//       debugPrint('Error initializing push messaging service: $e');
//     });
//   }

//   @override
//   void dispose() {
//     // Do NOT unsubscribe from the topic here, as the user may want to receive notifications even when the app is in the background
//     // _pushNotificationService.unsubscribeFromAllTopics();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Group Chat'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Provider.of<PushMessagingService>(context, listen: false)
//                   .unsubscribeFromAllTopics();
//               Provider.of<AuthenticationService>(context, listen: false)
//                   .logOut();
//             },
//             icon: Icon(
//               Icons.exit_to_app,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//         ],
//       ),
//       body: const Column(
//         children: [
//           Expanded(
//             child: MessageList(),
//           ),
//           NewMessageBar(),
//         ],
//       ),
//     );
//   }
// }
