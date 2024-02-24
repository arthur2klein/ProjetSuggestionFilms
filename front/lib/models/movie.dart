import 'package:suggestion_films/models/genre.dart';

class Movie {
  final String movieid;
  final String movietitle;
  final int releasedate;
  final String synopsis;
  final String director;
  final String imgurl;
  final double usernote;
  final double time;
  final List<Genre> genres;

  Movie({
    required this.movieid,
    required this.movietitle,
    required this.releasedate,
    required this.synopsis,
    required this.director,
    required this.imgurl,
    required this.usernote,
    required this.time,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieid: json['movieid'],
      movietitle: json['movietitle'],
      releasedate: json['releasedate'],
      synopsis: json['synopsis'],
      director: json['director'],
      imgurl: json['imgurl'],
      usernote: json['usernote'],
      time: json['time'],
      genres: json['genres'].map(
        (genre) => Genre.fromJson(genre),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieid': movieid,
      'movietitle': movietitle,
      'releasedate': releasedate,
      'synopsis': synopsis,
      'director': director,
      'imgurl': imgurl,
      'usernote': usernote,
      'time': time,
      'genres': genres.map(
        (genre) => genre.toJson(),
      ),
    };
  }
}
