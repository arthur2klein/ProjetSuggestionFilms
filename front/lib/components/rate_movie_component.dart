import 'package:flutter/material.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/movie_service.dart';

class RateMovieComponent extends StatefulWidget {
  final Movie movie;
  const RateMovieComponent({super.key, required this.movie});

  @override
  State<RateMovieComponent> createState() => _RateMovieComponentState();
}

class _RateMovieComponentState extends State<RateMovieComponent> {
  bool _sawMovie = false;
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('I\'ve seen the movie'),
                  Switch(
                    value: _sawMovie,
                    onChanged: (value) {
                      setState(() {
                        _sawMovie = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_sawMovie)
          Column(
            children: [
              const SizedBox(height: 16),
              Text('Rate this film $_rating'),
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
            ],
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void submit() {
    MovieService().setViewed(
      widget.movie,
      _sawMovie,
    );
    if (_sawMovie) {
      MovieService().setRating(
        widget.movie,
        _rating,
      );
    } else {
      MovieService().setRating(
        widget.movie,
        null,
      );
    }
  }
}
