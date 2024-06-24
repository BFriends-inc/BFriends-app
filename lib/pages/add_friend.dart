import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];

  void _searchUsers() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final results =
        await auth.searchUsers(_searchController.text, auth.user!.username);
    setState(() {
      _searchResults = results;
    });
  }

  void _sendFriendRequest(String friendUserId) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var currentUserId = auth.user!.id.toString(); // current user ID
    await auth.sendFriendRequest(currentUserId, friendUserId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Friend request sent')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthService>(context);
    final user = auth.user;
    //final nav = Provider.of<NavigationService>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          title: Text(
            'Find Friends!',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontStyle: theme.textTheme.headlineMedium!.fontStyle,
              fontSize: theme.textTheme.headlineSmall!.fontSize,
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by username',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchUsers,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final userFiltered = _searchResults[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 45,
                      height: 45,
                      child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            userFiltered.avatarURL.toString(),
                            fit: BoxFit.cover,
                          )),
                    ),
                    title: Text(userFiltered.username.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_add_alt_outlined),
                      onPressed: () =>
                          _sendFriendRequest(userFiltered.id.toString()),
                    ),
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
