import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';

class CGUPage extends StatelessWidget {
  const CGUPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: 'Conditions générales d\'utilisation',
      body: Center(
        child: Text('This page will present the Terms of Use.'),
      ),
      indexNavBar: 2,
    );
  }
}
