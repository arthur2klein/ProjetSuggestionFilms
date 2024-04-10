import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suggestion_films/models/genre.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/group_service.dart';
import 'package:suggestion_films/services/user_service.dart';

class MovieService {
  MovieService._privateConstructor();
  static final MovieService _instance = MovieService._privateConstructor();
  factory MovieService() {
    return _instance;
  }

  final String apiUrl = 'localhost';
  final int apiPort = 8000;

  Future<Movie?> fromId(String movieid) async {
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie',
      queryParameters: {
        'movieid': movieid,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse['data']);
    } else {
      return null;
    }
  }

  Future<List<Movie>> search(String query) async {
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/search',
      queryParameters: {
        'query': query,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Movie> movies = [];
      for (var movie in jsonResponse['data']) {
        movies.add(Movie.fromJson(movie));
      }
      return movies;
    } else {
      debugPrint('Search error');
      return [];
    }
  }

  Future<void> setRating(Movie movie, double? note) async {
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/rating',
    );
    final response = await http.post(
      uri,
      body: {
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
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/rating',
      queryParameters: {
        'user': UserService().currentUser!.userid,
        'movie': movie.movieid,
      },
    );
    final response = await http.get(uri);
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
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/seen',
      queryParameters: {
        'user': UserService().currentUser!.userid,
        'movie': movie.movieid,
      },
    );
    final response = await http.get(uri);
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
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/view',
    );
    final response = await http.post(
      uri,
      body: {
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
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/genres',
      queryParameters: {
        'movie': movie.movieid,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Genre> genres = [];
      for (var genre in jsonResponse['data']) {
        genres.add(Genre.fromJson(genre));
      }
      return genres;
    } else {
      debugPrint('Search error');
      return [];
    }
  }

  Future<List<Movie>> recommended() async {
    final List<String> userIds = GroupService()
        .currentGroup
        .map(
          (user) => user.userid,
        )
        .toList();
    final Uri uri = Uri(
      host: apiUrl,
      port: apiPort,
      path: '/movie/recommended',
      queryParameters: {
        'users': jsonEncode(userIds),
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Movie> movies = [];
      for (var movie in jsonResponse['data']) {
        movies.add(Movie.fromJson(movie));
      }
      return movies;
    }
    debugPrint('Search error');
    return [];
  }
}
