import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMovieCallback searchMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  Timer? _debouncedTimer;

  SearchMovieDelegate({
    required this.searchMovies,
  });

  void _onQueryChange(String query) {
    if (_debouncedTimer?.isActive ?? false) _debouncedTimer!.cancel();

    _debouncedTimer = Timer(const Duration(milliseconds: 500), () { 

     });
  }

  @override
  String get searchFieldLabel => 'Buscar pelídula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '', 
          icon: const Icon(Icons.clear)
        ),
      ),
  ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null), 
      icon: const Icon(Icons.arrow_back_ios_new_rounded)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('BuildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChange(query);

    return StreamBuilder(
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final List<Movie> movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
              movie : movies[index],
              onMovieSelected: close,
            );
          }
        );
      }
    );
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
            const SizedBox(width: 10),
    
            SizedBox(width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title, 
                style: textStyle.titleMedium
                ),
                
                (movie.overview.length > 100)
                  ? Text('${movie.overview.substring(0,100)}...')
                  : Text(movie.overview),
    
                Row(
                  children: [
                    Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                    const SizedBox(width: 5),
                    Text(
                      HumanFormats.number(movie.voteAverage, 1),
                      style: textStyle.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                    )
                  ],
                )
              ],
            ),)
          ],
        ),
      ),
    );
  }
}