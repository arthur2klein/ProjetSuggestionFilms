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
    return [
      Movie(
        movieid: '3',
        movietitle: 'Test',
        releasedate: 20151005,
        synopsis: """Synosis: 
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies est ac tincidunt pellentesque. Ut vitae sodales nulla, ac rhoncus arcu. Sed imperdiet accumsan nulla et sollicitudin. Nunc eros urna, viverra id lectus id, tincidunt imperdiet dui. Sed rhoncus mi id magna porta, vitae faucibus diam hendrerit. Nulla leo mauris, condimentum eget urna nec, suscipit elementum diam. Suspendisse ut metus nisi. Suspendisse et urna fermentum, ultrices sem ut, euismod dui. Curabitur sed condimentum ex. In feugiat elit vitae blandit porta. Integer dignissim, ex in finibus malesuada, felis lectus ullamcorper mi, placerat aliquet ipsum nulla id nisi. Sed tincidunt mattis consequat. Sed blandit ipsum at nulla imperdiet fringilla. Suspendisse eu risus non orci bibendum mattis. Duis sit amet urna pretium, condimentum turpis eget, euismod felis. Aenean justo metus, accumsan vitae justo in, rutrum hendrerit nibh.

Etiam turpis nunc, dictum non sapien ac, pharetra ultricies nisl. Donec lobortis iaculis quam eu varius. Nam id tellus vulputate, ultricies tortor venenatis, accumsan tellus. Sed at eros vehicula, iaculis mauris non, aliquam mi. Pellentesque venenatis sagittis diam, sit amet lacinia metus faucibus et. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus felis leo, malesuada in venenatis maximus, auctor nec sapien. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur id feugiat odio, eget tincidunt justo. Etiam ut fringilla magna.

Phasellus eu diam bibendum, vulputate nisl nec, euismod lorem. Aliquam sodales dignissim dictum. Nullam suscipit mi a enim cursus, at dictum nulla convallis. Suspendisse lobortis vestibulum pretium. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Ut sed lobortis mauris, id scelerisque dui. Sed semper a enim vel efficitur. Sed commodo mi ut mauris luctus tincidunt. Fusce fermentum sodales nisl sed pretium. Suspendisse hendrerit, libero sit amet facilisis convallis, ante neque varius nisi, quis faucibus tellus quam at augue. Curabitur libero eros, imperdiet efficitur scelerisque non, tempus condimentum erat. In fringilla, nunc eu venenatis dignissim, diam magna sagittis lorem, non faucibus massa nunc at libero. Etiam in diam in lorem sollicitudin laoreet gravida at elit.

Donec dapibus purus sit amet odio egestas tempor. Pellentesque vehicula eros vitae lacus egestas, eu tincidunt enim vulputate. Vestibulum posuere mi quis metus varius volutpat. Vestibulum ut aliquet velit, in blandit lacus. Curabitur iaculis at augue ut pellentesque. Nam eget justo luctus, dictum tellus nec, malesuada enim. Pellentesque non sem et lorem feugiat mattis eu non ipsum. Cras ornare, sem id rhoncus congue, orci odio tincidunt arcu, in maximus metus lacus at dui. In felis nibh, consectetur vel elit eget, iaculis rutrum nibh. Fusce risus dolor, mollis tincidunt velit a, pellentesque porttitor sem. Phasellus et augue metus.

Ut tristique commodo justo, ac rhoncus massa pellentesque ut. Quisque aliquet arcu vel feugiat blandit. Donec in arcu quis mi dictum varius et vitae quam. Duis a magna nec lectus molestie tempus. Quisque sed enim lorem. Donec nec velit eu dui congue imperdiet. Aliquam erat volutpat. Integer ac nibh eu enim tristique tincidunt. Aliquam viverra dignissim aliquam. Etiam sed lacus dapibus purus gravida euismod. Quisque euismod, augue nec sagittis vulputate, elit elit lacinia risus, euismod ultricies dolor enim sed sem. Aliquam urna velit, dignissim et nunc in, pretium convallis eros. """,
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
        'hasSeen':  saw?'1':'0',
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
