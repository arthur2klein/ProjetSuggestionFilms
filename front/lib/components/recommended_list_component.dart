import 'package:flutter/material.dart';
import 'package:suggestion_films/components/movie_component.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/movie_service.dart';

class RecommendedListComponent extends StatefulWidget {
  const RecommendedListComponent({super.key});

  @override
  State<RecommendedListComponent> createState() =>
      _RecommendedListComponentState();
}

class _RecommendedListComponentState extends State<RecommendedListComponent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MovieService().recommended(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final recommended = snapshot.data ?? [];
          return ListView.builder(
            itemCount: recommended.length,
            itemBuilder: (BuildContext context, int index) {
              Movie movie = recommended[index];
              return MovieComponent(
                movie: movie,
                isShort: true,
              );
            },
          );
        }
      },
    );
  }
}
