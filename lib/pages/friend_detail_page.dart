import 'package:flutter/material.dart';
import 'package:bfriends_app/model/friend.dart';
import 'package:bfriends_app/pages/chat_page.dart';
import 'package:like_button/like_button.dart';

class FriendDetailPage extends StatefulWidget {
  final Friend friend;

  const FriendDetailPage({required this.friend, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendDetailPageState createState() => _FriendDetailPageState();
}

class _FriendDetailPageState extends State<FriendDetailPage> {
  bool isPressedChat = false;

  void showBlockConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.friend.block
                  ? 'Unblock ${widget.friend.name}?'
                  : 'Block ${widget.friend.name}?',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.friend.block) ...[
              const Row(
                children: [
                  Icon(Icons.event_busy),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This account won\'t be able to see your activities anymore',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.chat),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You\'ll not be able to chat with this account until you unblock this account',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
            if (widget.friend.block) ...[
              Text(
                'Are you sure you want to unblock ${widget.friend.name}?',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
        actions: [
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.friend.block = !widget.friend.block;
                      widget.friend.favorite = false;
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    widget.friend.block ? 'Unblock' : 'Block',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (!widget.friend.block) {
      setState(() {
        widget.friend.favorite = !widget.friend.favorite;
      });
    }
    return widget.friend.favorite;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.9,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.friend.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color:
                      const Color.fromARGB(255, 219, 201, 237).withOpacity(0.7),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2.5,
            left: 20,
            right: 20,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: PageView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.friend.block
                              ? '${widget.friend.name} is blocked'
                              : 'NAME',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.friend.block
                              ? 'To view this account\'s information, you\'ll have to unblock first.'
                              : widget.friend.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          widget.friend.block ? '' : 'PREFERRED LANGUAGE',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.friend.block
                              ? ''
                              : widget.friend.languages.join(' / '),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          widget.friend.block ? '' : 'HOBBIES / INTERESTS',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.friend.block
                              ? ''
                              : widget.friend.hobbies.join(' / '),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        widget.friend.block
                            ? 'Currently blocked'
                            : 'Additional Info',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: SizedBox(
              width: 120,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      debugPrint('back button triggered');
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 1),
                  const Text(
                    'Back',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 75,
            right: 25,
            child: LikeButton(
              isLiked: widget.friend.favorite,
              onTap: onLikeButtonTapped,
              circleColor: const CircleColor(
                start: Color(0xFFF44336),
                end: Color(0xFFF44336),
              ),
              bubblesColor: const BubblesColor(
                dotPrimaryColor: Color(0xFFF44336),
                dotSecondaryColor: Color(0xFFF44336),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.favorite,
                  color: isLiked
                      ? const Color.fromARGB(234, 209, 0, 0)
                      : Colors.grey,
                );
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.chat),
              color: Colors.black,
              onPressed: () {
                if (!widget.friend.block) {
                  setState(() {
                    isPressedChat = !isPressedChat;
                  });

                  // Navigate to ChatPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(friend: widget.friend),
                    ),
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: 120,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    showBlockConfirmationDialog();
                  },
                  child: Center(
                    child: Text(
                      widget.friend.block ? 'Unblock' : 'Block',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
