import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:suggestion_films/models/movie.dart';

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
    return [
      Movie(
        movieid: '3',
        movietitle: 'Test',
        releasedate: 20151005,
        synopsis: 'Synosis',
        director: 'Director',
        imgurl:
            'https://marsner.com/wp-content/uploads/test-driven-development-TDD.png',
        usernote: 3.5,
        time: 4214,
      ),
    ];
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
}
