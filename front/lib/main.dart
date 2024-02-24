import 'package:flutter/material.dart';
import 'package:suggestion_films/pages/cgu_page.dart';
import 'package:suggestion_films/pages/film_page.dart';
import 'package:suggestion_films/pages/gestion_groupe_page.dart';
import 'package:suggestion_films/pages/gestion_user.dart';
import 'package:suggestion_films/pages/home_page.dart';
import 'package:suggestion_films/pages/recommended_page.dart';
import 'package:suggestion_films/pages/search_film_page.dart';
import 'package:suggestion_films/pages/user_creation_page.dart';
import 'package:suggestion_films/pages/user_login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suggestion de Films',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/create-account': (context) => const UserCreationPage(),
        '/film': (context) => const FilmPage(),
        '/group': (context) => const GestionGroupePage(),
        '/login': (context) => const UserLoginPage(),
        '/manage': (context) => const GestionUserPage(),
        '/recommended': (context) => const RecommendedPage(),
        '/search': (context) => const SearchFilmPage(),
        '/tou': (context) => const CGUPage(),
      },
    );
  }
}
