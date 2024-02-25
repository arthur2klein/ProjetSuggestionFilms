import 'package:flutter/material.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/components/rate_movie_component.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/movie_service.dart';

class RateMoviePage extends StatelessWidget {
  const RateMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final Movie? movie = arguments?['movie'] ??
        MovieService().fromId(
          arguments?['movieid'],
        );
    if (movie == null) {
      return Center(
        child: Text(
          'Movie not found',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    return MyScaffold(
      body: RateMovieComponent(movie: movie),
      title: 'Rate a Movie',
    );
  }
}
