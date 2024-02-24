import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';

class FilmPage extends StatelessWidget {
  const FilmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final int? filmId = arguments?['filmId'];
    return MyScaffold(
      body: Text('This page will show the film with id $filmId'), title: 'Film', indexNavBar: 0,
    );
  }
}
