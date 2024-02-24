import 'package:flutter/material.dart';
import 'package:suggestion_films/services/user_service.dart';

class MyScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final int indexNavBar;

  const MyScaffold({
    super.key,
    required this.title,
    required this.body,
    this.indexNavBar = 0,
  });

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  final List<String> _pages = [
    '/',
    '/search',
    '/tou',
    '/group',
  ];

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            (UserService().currentUser == null ? '/login' : '/manage'),
          );
        },
        child: const Icon(Icons.person),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Recommended',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search a Film',
          ),
          const NavigationDestination(
            icon: Icon(Icons.handshake),
            label: 'Terms of Use',
          ),
          if (UserService().currentUser != null)
            const NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Group Management',
            ),
        ],
        onDestinationSelected: (int index) {
          Navigator.of(context).pushReplacementNamed(
            _pages[index],
          );
        },
        selectedIndex: widget.indexNavBar,
      ),
    );
  }
}
