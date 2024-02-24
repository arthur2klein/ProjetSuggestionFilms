import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';

class SearchFilmPage extends StatelessWidget {
  const SearchFilmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyScaffold(
      title: 'Search a Film',
      body: Text(
        'This page will allow the user to search films',
      ),
      indexNavBar: 1,
    );
  }
}
