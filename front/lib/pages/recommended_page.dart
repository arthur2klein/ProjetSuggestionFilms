import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/components/recommended_list_component.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      body: Column(
        children: [
          Text(
            'Recommended',
          ),
          Expanded(
            child: RecommendedListComponent(),
          ),
        ],
      ),
      title: 'Recommended',
    );
  }
}
