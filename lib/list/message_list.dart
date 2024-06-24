// import 'package:flutter/material.dart';
// import 'package:bfriends_app/view_models/all_messages_vm.dart';
// import 'package:bfriends_app/view_models/me_vm.dart';
// import 'package:provider/provider.dart';

// class MessageList extends StatelessWidget {
//   const MessageList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final meViewModel = Provider.of<MeViewModel>(context);
//     final allMessagesViewModel = Provider.of<AllMessagesViewModel>(context);

//     if (meViewModel.me == null || allMessagesViewModel.isInitializing) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     final me = meViewModel.me!;
//     final messages = allMessagesViewModel.messages;

//     if (messages.isEmpty) {
//       return const Center(
//         child: Text('No messages.'),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.only(
//         top: 16,
//         bottom: 16,
//         left: 8,
//         right: 8,
//       ),
//       reverse: true,
//       itemCount: messages.length,
//       itemBuilder: (ctx, index) {
//         final message = messages[index];
//         final nextMessage =
//             index + 1 < messages.length ? messages[index + 1] : null;
//         final prevMessage = index - 1 >= 0 ? messages[index - 1] : null;

//         final messageUserId = message.userId;
//         final nextMessageUserId = nextMessage?.userId;
//         final isNextUserSame = nextMessageUserId == messageUserId;
//         final preMessageUserId = prevMessage?.userId;
//         final isPreUserSame = preMessageUserId == messageUserId;

//         if (isNextUserSame) {
//           return MessageBubble(
//             text: message.text,
//             isMine: me.id == messageUserId,
//             isLast: !isPreUserSame,
//             onDelete: me.isModerator
//                 ? () => allMessagesViewModel.deleteMessage(message.id!)
//                 : null,
//           );
//         } else {
//           return MessageBubble.withUser(
//             userAvatarUrl: message.userAvatarUrl,
//             userName: message.userName,
//             text: message.text,
//             isMine: me.id == messageUserId,
//             isLast: !isPreUserSame,
//             onDelete: me.isModerator
//                 ? () => allMessagesViewModel.deleteMessage(message.id!)
//                 : null,
//           );
//         }
//       },
//     );
//   }
// }
