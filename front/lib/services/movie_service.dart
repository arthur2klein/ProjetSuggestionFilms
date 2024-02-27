import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suggestion_films/models/genre.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/user_service.dart';

class MovieService {
  MovieService._privateConstructor();
  static final MovieService _instance = MovieService._privateConstructor();
  factory MovieService() {
    return _instance;
  }

  final String apiUrl = 'api';

  Future<Movie?> fromId(String movieid) async {
    final response = await http.get(
      Uri.parse('$apiUrl/movie'),
      headers: {'movieid': movieid},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse['data']);
    } else {
      return null;
    }
  }

  Future<List<Movie>> search(String query) async {
    var movies = [
      Movie(
        movieid: '0',
        movietitle: 'banane',
        releasedate: 20151005,
        synopsis: "my synosis ",
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
      Movie(
        movieid: '1',
        movietitle: 'pomme',
        releasedate: 20151005,
        synopsis: "my synosis ",
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
      Movie(
        movieid: '2',
        movietitle: 'citron',
        releasedate: 20151005,
        synopsis: "my synosis ",
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
      Movie(
        movieid: '3',
        movietitle: 'orange',
        releasedate: 20151005,
        synopsis: "my synosis ",
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
      Movie(
        movieid: '4',
        movietitle: 'kiwi',
        releasedate: 20151005,
        synopsis: "my synosis ",
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
      Movie(
        movieid: '5',
        movietitle: 'fraise',
        releasedate: 20151005,
        synopsis: "my synosis ",
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
    ];
    return movies
        .where(
          (movie) => movie.movietitle.contains(query),
        )
        .toList();
    final response = await http.get(
      Uri.parse('$apiUrl/movie/search'),
      headers: {'query': query},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'].map(
        (movie) => Movie.fromJson(movie),
      );
    } else {
      debugPrint('Search error');
      return [];
    }
  }

  Future<void> setRating(Movie movie, double? note) async {
    final response = await http.post(
      Uri.parse('$apiUrl/movie/rating'),
      headers: {
        'user': UserService().currentUser!.userid,
        'movie': movie.movieid,
        'rating': note.toString(),
      },
    );
    if (response.statusCode != 200) {
      debugPrint('Error when setting note');
    }
  }

  Future<double?> getNote(Movie movie) async {
    final response = await http.get(
      Uri.parse('$apiUrl/movie/rating'),
      headers: {
        'user': UserService().currentUser!.userid,
        'movie': movie.movieid,
      },
    );
    if (response.statusCode != 200) {
      return null;
    } else {
      final jsonResponse = json.decode(response.body);
      try {
        return double.parse(jsonResponse['rating']);
      } catch (_) {
        return null;
      }
    }
  }

  Future<bool> userSaw(Movie movie) async {
    return false;
    final response = await http.get(
      Uri.parse('$apiUrl/user/movie'),
      headers: {'movie': movie.movieid},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'] == '1';
    } else {
      debugPrint('Search error');
      return false;
    }
  }

  Future<void> setViewed(
    Movie movie,
    bool saw,
  ) async {
    final response = await http.post(
      Uri.parse('$apiUrl/movie/rating'),
      headers: {
        'user': UserService().currentUser!.userid,
        'movie': movie.movieid,
        'hasSeen': saw ? '1' : '0',
      },
    );
    if (response.statusCode != 200) {
      debugPrint('Error when setting note');
    }
  }

  Future<List<Genre>> getGenres(Movie movie) async {
    return [
      Genre(genreid: '', genrename: 'genre1'),
      Genre(genreid: '', genrename: 'genre2'),
      Genre(genreid: '', genrename: 'genre3'),
      Genre(genreid: '', genrename: 'genre4'),
      Genre(genreid: '', genrename: 'genre5'),
      Genre(genreid: '', genrename: 'genre6'),
      Genre(genreid: '', genrename: 'genre7'),
      Genre(genreid: '', genrename: 'genre8'),
    ];
    final response = await http.get(
      Uri.parse('$apiUrl/movie/genres'),
      headers: {'movie': movie.movieid},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['genres'].map(
        (genre) => Genre.fromJson(genre),
      );
    } else {
      debugPrint('Search error');
      return [];
    }
  }

  Future<List<Movie>> recommended() async {
    return <Movie>[
      Movie(
        movieid: '1',
        movietitle: 'movie1',
        releasedate: 1,
        synopsis: 'Synopsis0',
        director: 'Direcor1',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '2',
        movietitle: 'movie2',
        releasedate: 2,
        synopsis: 'Synopsis0',
        director: 'Direcor2',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '3',
        movietitle: 'movie3',
        releasedate: 3,
        synopsis: 'Synopsis0',
        director: 'Direcor3',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '4',
        movietitle: 'movie4',
        releasedate: 4,
        synopsis: 'Synopsis0',
        director: 'Direcor4',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '5',
        movietitle: 'movie5',
        releasedate: 5,
        synopsis: 'Synopsis0',
        director: 'Direcor5',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '6',
        movietitle: 'movie6',
        releasedate: 6,
        synopsis: 'Synopsis0',
        director: 'Direcor6',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '7',
        movietitle: 'movie7',
        releasedate: 7,
        synopsis: 'Synopsis0',
        director: 'Direcor7',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '8',
        movietitle: 'movie8',
        releasedate: 8,
        synopsis: 'Synopsis0',
        director: 'Direcor8',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
      Movie(
        movieid: '9',
        movietitle: 'movie9',
        releasedate: 9,
        synopsis: 'Synopsis0',
        director: 'Direcor9',
        imgurl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/617px-Kubernetes_logo_without_workmark.svg.png',
        usernote: 3.9,
        time: 120,
      ),
    ];
    final response = await http.get(
      Uri.parse('$apiUrl/movie/recommended'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'].map(
        (movie) => Movie.fromJson(movie),
      );
    } else {
      debugPrint('Search error');
      return [];
    }
  }
}
