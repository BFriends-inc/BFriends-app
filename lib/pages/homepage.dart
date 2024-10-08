import 'package:bfriends_app/pages/events_page.dart';
import 'package:bfriends_app/pages/friends_page.dart';
import 'package:bfriends_app/pages/home_page.dart';
import 'package:bfriends_app/pages/profile_page.dart';
import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum NavigationTabs {
  home,
  friends,
  events,
  profile,
}

class HomePage extends StatelessWidget {
  final NavigationTabs selectedTabs;
  const HomePage({super.key, required this.selectedTabs});

  void _tapBottomNavigationBarItem(BuildContext context, index) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goHome(
        tab: index == 0
            ? NavigationTabs.home
            : (index == 1
                ? NavigationTabs.friends
                : (index == 2
                    ? NavigationTabs.events
                    : NavigationTabs.profile)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> tabs = [
      {
        'page': const MapPage(),
      },
      {
        'page': const FriendsPage(),
      },
      {
        'page': const EventsPage(),
      },
      {
        'page': const ProfilePage(),
      },
    ];

    return Scaffold(
      body: tabs[selectedTabs.index]['page'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 5.0,
        selectedFontSize: 12.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: theme.colorScheme.tertiary,
        onTap: (index) => _tapBottomNavigationBarItem(context, index),
        currentIndex: selectedTabs.index,
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
