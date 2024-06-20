// import 'package:flutter/material.dart';
// import 'package:bfriends_app/models/message.dart';
// import 'package:bfriends_app/view_models/all_messages_vm.dart';
// import 'package:bfriends_app/view_models/me_vm.dart';
// import 'package:provider/provider.dart';

// class NewMessageBar extends StatefulWidget {
//   const NewMessageBar({super.key});

//   @override
//   State<NewMessageBar> createState() {
//     return _NewMessageBarState();
//   }
// }

// class _NewMessageBarState extends State<NewMessageBar> {
//   final _messageController = TextEditingController();

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   void _submitMessage() async {
//     final enteredMessage = _messageController.text;

//     if (enteredMessage.trim().isEmpty) {
//       return;
//     }

//     FocusScope.of(context).unfocus();
//     _messageController.clear();

//     final meViewModel = Provider.of<MeViewModel>(context, listen: false);
//     final allMessagesViewModel =
//         Provider.of<AllMessagesViewModel>(context, listen: false);

//     if (meViewModel.me == null) {
//       return;
//     }

//     final me = meViewModel.me!;

//     allMessagesViewModel.addMessage(
//       Message(
//         text: enteredMessage,
//         userId: me.id,
//         userName: me.name,
//         userAvatarUrl: me.avatarUrl,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//       color: Theme.of(context).colorScheme.surfaceVariant,
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _messageController,
//                   textCapitalization: TextCapitalization.sentences,
//                   autocorrect: true,
//                   enableSuggestions: true,
//                   decoration:
//                       const InputDecoration(labelText: 'Send a message...'),
//                 ),
//               ),
//               IconButton(
//                 color: Theme.of(context).colorScheme.primary,
//                 icon: const Icon(
//                   Icons.send,
//                 ),
//                 onPressed: _submitMessage,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
