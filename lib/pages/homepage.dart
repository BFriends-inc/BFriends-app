import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum NavigationTabs {
  home,
  friends,
  events,
  profile,
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _tapBottomNavigationBarItem(BuildContext context, index) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    //FIXME: add navigation & tab change functionality.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'BFriends',
          style: theme.primaryTextTheme.headlineMedium,
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: theme.colorScheme.background,
      ),
      body: Center(
        child: Text(
          'This is the homepage.',
          style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: theme.textTheme.bodyMedium?.fontSize),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: theme.colorScheme.tertiary,
        onTap: (index) => _tapBottomNavigationBarItem(context, index),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on_outlined,
              semanticLabel: 'Home',
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_outlined,
              semanticLabel: 'Friends',
            ),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_outlined,
              semanticLabel: 'Events',
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              semanticLabel: 'Profile',
            ),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
