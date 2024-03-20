import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/services/user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (UserService().currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          Navigator.of(context).pushReplacementNamed(
            '/recommended',
          );
        },
      );
    }
    return const MyScaffold(
      title: 'Suggestion de Films',
      body: Center(
        child: Text('Please Login to begin'),
      ),
      indexNavBar: 0,
    );
  }
}
