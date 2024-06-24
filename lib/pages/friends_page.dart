import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/model/friend.dart';
import 'package:bfriends_app/pages/chat_page.dart';
import 'package:bfriends_app/pages/friend_detail_page.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Friend> friends = [
    Friend('Kenji', 'assets/images/sports_marker.png', ['English'],
        ['Trading Cards', 'Football'], false, false),
    Friend('Ball', 'assets/images/whitelogo.png', ['English', 'ไทย'],
        ['Trading Cards'], false, false),
    Friend('Poom', 'assets/images/whitelogo.png', ['English', '中文'],
        ['Trading Cards', 'Football'], false, false),
    Friend('Jianna', 'assets/images/sports_marker.png', ['한국어', 'English'],
        ['Reading', 'Trading Cards'], false, false),
    Friend('Steph', 'assets/images/sports_marker.png', ['한국어', 'English'],
        ['Reading', 'Trading Cards'], false, false),
    Friend('Michael1', 'assets/images/sports_marker.png', ['한국어', 'English'],
        ['Reading', 'Trading Cards'], false, false),
    Friend('Michael2', 'assets/images/sports_marker.png', ['한국어', 'English'],
        ['Reading', 'Trading Cards'], false, false),
  ];

  String selectedCategory = 'Friends';
  String searchQuery = '';

  List<Friend> get selectedFriends {
    List<Friend> filteredFriends;
    switch (selectedCategory) {
      case 'Favourites':
        filteredFriends = friends.where((friend) => friend.favorite).toList();
        break;
      case 'Groups':
        filteredFriends = friends;
        break;
      default:
        filteredFriends = friends;
        break;
    }
    if (searchQuery.isNotEmpty) {
      filteredFriends = filteredFriends
          .where((friend) =>
              friend.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredFriends;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Provider.of<NavigationService>(context);
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            'Friend Lists',
            style: TextStyle(
              fontSize: theme.primaryTextTheme.headlineMedium?.fontSize,
              fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                nav.pushPageOnPage(
                    context: context, destination: 'accept_friend');
              },
              icon: Icon(
                (user!.requests!.isEmpty)
                    ? Icons.mail_outline_rounded
                    : Icons.mail,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt_outlined),
              onPressed: () {
                nav.pushPageOnPage(context: context, destination: 'add_friend');
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Favourites';
                    });
                  },
                  child: Text(
                    'Favourites',
                    style: TextStyle(
                      color: selectedCategory == 'Favourites'
                          ? const Color.fromARGB(255, 137, 79, 190)
                          : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Friends';
                    });
                  },
                  child: Text(
                    'Friends',
                    style: TextStyle(
                      color: selectedCategory == 'Friends'
                          ? const Color.fromARGB(255, 137, 79, 190)
                          : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Groups';
                    });
                  },
                  child: Text(
                    'Groups',
                    style: TextStyle(
                      color: selectedCategory == 'Groups'
                          ? const Color.fromARGB(255, 137, 79, 190)
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                key: ValueKey<String>(selectedCategory),
                itemCount: selectedFriends.length,
                itemBuilder: (context, index) {
                  final friend = selectedFriends[index];
                  // decide the delay time here
                  final delay = Duration(milliseconds: 200 * index);
                  return FriendTile(
                    friend: friend,
                    delay: delay,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendTile extends StatefulWidget {
  final Friend friend;
  final Duration delay;

  const FriendTile({required this.friend, required this.delay, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendTileState createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    // Start animation after the specified delay (200 ms)
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, (1 - _animation.value) * 50),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: Card(
        color: (widget.friend.block == true)
            ? const Color.fromARGB(255, 212, 208, 215)
            : const Color.fromARGB(255, 222, 219, 224),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendDetailPage(friend: widget.friend),
              ),
            );
          },
          leading: ClipOval(
            child: Image.asset(
              widget.friend.imagePath,
              fit: BoxFit.cover,
              width: 40.0,
              height: 40.0,
            ),
          ),
          title: Text(
            widget.friend.name,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.friend.languages.join(', '),
                  style: const TextStyle(fontSize: 13.0)),
              Text(widget.friend.hobbies.join(', '),
                  style: const TextStyle(fontSize: 13.0)),
            ],
          ),
        ),
      ),
    );
  }
}
