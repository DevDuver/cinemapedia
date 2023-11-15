import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageRepository{
  
  Future<bool> toggleFavorite(Movie movie);

  Future<bool> isMovieFavorite(int movieId);

  Future<List<Movie>> loadMovies({int limit = 20, offset = 0});

}