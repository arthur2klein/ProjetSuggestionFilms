import 'package:flutter/material.dart';
import 'package:suggestion_films/components/movie_component.dart';
import 'package:suggestion_films/components/my_scaffold.dart';
import 'package:suggestion_films/models/movie.dart';
import 'package:suggestion_films/services/movie_service.dart';

class SearchFilmPage extends StatefulWidget {
  const SearchFilmPage({super.key});

  @override
  State<SearchFilmPage> createState() => _SearchFilmPageState();
}

class _SearchFilmPageState extends State<SearchFilmPage> {
  TextEditingController searchController = TextEditingController();
  List<Movie> searchedMovies = [];

  Future<void> searchFilms(String query) async {
    List<Movie> search = await MovieService().search(query);
    setState(() {
      searchedMovies = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Search a Movie',
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: searchFilms,
            decoration: InputDecoration(
              labelText: 'Search by name',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  searchFilms('');
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchedMovies.length,
              itemBuilder: (context, index) {
                Movie movie = searchedMovies[index];
                return MovieComponent(movie: movie, isShort: true);
              },
            ),
          ),
        ],
      ),
      indexNavBar: 1,
    );
  }
}
