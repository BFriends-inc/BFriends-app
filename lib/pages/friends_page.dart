import 'package:flutter/material.dart';
import 'package:bfriends_app/model/friend.dart';
import 'package:bfriends_app/pages/chat_page.dart';
import 'package:bfriends_app/pages/friend_detail_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
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

    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
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
                  return FriendTile(friend: friend);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final Friend friend;

  const FriendTile({required this.friend, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (friend.block == true)
          ? const Color.fromARGB(255, 133, 127, 139)
          : const Color.fromARGB(255, 219, 201, 237),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendDetailPage(friend: friend),
            ),
          );
        },
        leading: ClipOval(
          child: Image.asset(
            friend.imagePath,
            fit: BoxFit.cover,
            width: 40.0,
            height: 40.0,
          ),
        ),
        title: Text(
          friend.name,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(friend.languages.join(', '),
                style: const TextStyle(fontSize: 13.0)),
            Text(friend.hobbies.join(', '),
                style: const TextStyle(fontSize: 13.0)),
          ],
        ),
      ),
    );
  }
}
