import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      body: Center(
        child: Text(
          'This page will show the films recommended for the group.',
        ),
      ),
      title: 'Recommended',
    );
  }
}
