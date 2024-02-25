import 'package:flutter/material.dart';
import 'package:suggestion_films/models/movie.dart';

class RateMovieComponent extends StatefulWidget {
  final Movie movie;
  const RateMovieComponent({super.key, required this.movie});

  @override
  State<RateMovieComponent> createState() => _RateMovieComponentState();
}

class _RateMovieComponentState extends State<RateMovieComponent> {
  @override
  Widget build(BuildContext context) {
    return const Text(
        'Switch to chose if I saw the movie. The remaining of the content appear if I saw the movie: You can then give a note.');
  }
}

