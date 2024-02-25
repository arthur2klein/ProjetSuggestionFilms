import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/movie_service.dart';

class MovieComponent extends StatelessWidget {
  final Movie movie;
  final bool isShort;
  const MovieComponent({
    super.key,
    required this.movie,
    this.isShort = false,
  });

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  String formatDate(int nSeconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(nSeconds * 1000);
    String formattedDate =
        '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
    return formattedDate;
  }

  String formatTime(int nSeconds) {
    Duration duration = Duration(seconds: nSeconds);
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    String formattedTime =
        '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    if (isShort) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/movie',
                arguments: {'movie': movie},
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(movie.imgurl, width: 200),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(movie.movietitle),
                        const SizedBox(width: 32),
                        Text(formatDate(movie.releasedate)),
                      ],
                    ),
                    Text('Director: ${movie.director}'),
                    Text(
                      'Durée: ${formatTime(movie.time.toInt())}',
                    ),
                    Text('Usernote: ${movie.usernote}'),
                  ],
                ),
                FutureBuilder<bool>(
                  future: MovieService().userSaw(movie),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('FutureBuilder Error: $snapshot.error}');
                    } else {
                      bool sawed = snapshot.data ?? false;
                      if (sawed) {
                        return const Icon(EvaIcons.eyeOutline);
                      } else {
                        return const Icon(EvaIcons.eyeOff);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder<bool>(
                  future: MovieService().userSaw(movie),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('FutureBuilder Error: $snapshot.error}');
                    } else {
                      bool sawed = snapshot.data ?? false;
                      if (sawed) {
                        return const Icon(EvaIcons.eyeOutline);
                      } else {
                        return const Icon(EvaIcons.eyeOff);
                      }
                    }
                  },
                ),
                Text(
                  movie.movietitle,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Release date:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(formatDate(movie.releasedate)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Director:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(movie.director),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'User note:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${movie.usernote}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(formatTime(movie.time.toInt())),
                      ],
                    ),
                  ],
                ),
                Image.network(movie.imgurl, width: 500, height: 300),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Synopsis:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(movie.synopsis),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/rate',
                    arguments: {
                      'movie': movie,
                    },
                  );
                },
                child: const Text('Note this film'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
