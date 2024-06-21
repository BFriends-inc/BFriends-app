import 'package:flutter/material.dart';
import 'package:bfriends_app/model/friend.dart';
import 'package:flutter/widgets.dart';

//prob fix the UI laterr

//change to stateful now since we have to interact with the page
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  //temp
  List<Friend> friends = [
    Friend('Kenji', 'assets/images/sports_marker.png', ['English'], ['Trading Cards', 'Football'], false, false),
    Friend('Ball', 'assets/images/whitelogo.png', ['English', 'ไทย'], ['Trading Cards'], false, false),
    Friend('Poom', 'assets/images/whitelogo.png', ['English', '中文'], ['Trading Cards', 'Football'], false, false),
    Friend('Jianna', 'assets/images/sports_marker.png', ['한국어', 'English'], ['Reading', 'Trading Cards'], false, false),
    Friend('Steph', 'assets/images/sports_marker.png', ['한국어', 'English'], ['Reading', 'Trading Cards'], false, false),
    Friend('Michael1', 'assets/images/sports_marker.png', ['한국어', 'English'], ['Reading', 'Trading Cards'], false, false),
    Friend('Michael2', 'assets/images/sports_marker.png', ['한국어', 'English'], ['Reading', 'Trading Cards'], false, false),
  ];

  String selectedCategory = 'Friends';
  String searchQuery = '';
  //switch case here
  List<Friend> get selectedFriends {
    List<Friend> filteredFriends;
    switch (selectedCategory) {
      case 'Favourites':
        filteredFriends = friends.where((friend) => friend.favorite).toList();
        break;
        //return friends.where((friend) => friend.favorite).toList();
      case 'Groups':
        filteredFriends = friends;
        break;
        //return friends;
      default:
        filteredFriends = friends;
        break;
        //return friends;
    }
    if (searchQuery.isNotEmpty) {
      filteredFriends = filteredFriends
      //force all of the input to be lower
          .where((friend) =>
          friend.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
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
                      color: selectedCategory == 'Favourites' ? const Color.fromARGB(255, 137, 79, 190): Colors.black,
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
                      color: selectedCategory == 'Friends' ? const Color.fromARGB(255, 137, 79, 190) : Colors.black,
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
                      color: selectedCategory == 'Groups' ? const Color.fromARGB(255, 137, 79, 190) : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // after choosing the content then
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
      //the space between each cards
      color: (friend.block == true) ? const Color.fromARGB(255, 133, 127, 139) : const Color.fromARGB(255, 219, 201, 237),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        //visit frd detail page
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendDetailPage(friend: friend),
            ),
          );
        },
        //with purple background
        // leading: CircleAvatar(
        //   backgroundImage: AssetImage(friend.imagePath),
        // ),
        //with none bg but hasnt fitted ?
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
            Text(friend.languages.join(', '),style: const TextStyle(
            fontSize: 13.0)),
            Text(friend.hobbies.join(', '),style: const TextStyle(
            fontSize: 13.0)),
          ],
        ),
      ),
    );
  }
}

class FriendDetailPage extends StatefulWidget {
  final Friend friend;

  const FriendDetailPage({required this.friend, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendDetailPageState createState() => _FriendDetailPageState();
}

class _FriendDetailPageState extends State<FriendDetailPage> {
  bool isPressedChat = false;

  // show the confirmation dialog
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
            widget.friend.block ? 'Unblock ${widget.friend.name}?' : 'Block ${widget.friend.name}?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
          //case abt to block
          if (!widget.friend.block) ...[
            const Row(
              children: [
                Icon(Icons.event_busy),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This account won\'t be able to see your activities anymore',
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
          //case abt to unblock
          if (widget.friend.block) ...[
            Text(
              'Are you sure you want to unblock ${widget.friend.name}?',
              style: const TextStyle(
                fontSize: 16,
              ),
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
                  //primary: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  setState(() {
                    widget.friend.block = !widget.friend.block;
                    widget.friend.favorite = false;
                    //need this? ok we need it to go away after confirm
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  widget.friend.block ? 'Unblock' : 'Block',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
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
                  color: const Color.fromARGB(255, 219, 201, 237).withOpacity(0.7),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.friend.block
                              ? 'To view this account\'s information, you\'ll have to unblock first.'
                              : widget.friend.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          widget.friend.block
                              ? ''
                              : 'PREFERRED LANGUAGE',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.friend.block
                              ? ''
                              : widget.friend.languages.join(' / '),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          widget.friend.block
                              ? ''
                              : 'HOBBIES / INTERESTS',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.friend.block
                              ? ''
                              : widget.friend.hobbies.join(' / '),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
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
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
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
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.favorite),
              color: widget.friend.favorite
                  ? const Color.fromARGB(156, 255, 241, 116)
                  : Colors.black,
              onPressed: () {
                if(!widget.friend.block){
                setState(() {
                  widget.friend.favorite = !widget.friend.favorite;
                });
              }
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.chat),
              color:
                  isPressedChat ? const Color.fromARGB(156, 255, 241, 116) : Colors.black,
              onPressed: () {
                if(!widget.friend.block){
                setState(() {
                  isPressedChat = !isPressedChat;
                });
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