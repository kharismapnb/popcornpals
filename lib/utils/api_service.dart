import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart'; // Pastikan Anda mengimpor model Movie

class ApiService {
  static const String apiKey = 'aa6b4f6faf2ad4d8c7841b907f711c7d';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    const String url = '$baseUrl/movie/popular?api_key=$apiKey';
    return _fetchMovies(url);
  }

  Future<List<Movie>> getRecommendedMovies() async {
    const String url = '$baseUrl/movie/top_rated?api_key=$apiKey';
    final movies = await _fetchMovies(url);
    return movies.where((movie) => movie.rating > 8.5).toList();
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId';
    return _fetchMovies(url);
  }

  Future<List<Movie>> searchMovies(String query) async {
    final String url = '$baseUrl/search/movie?api_key=$apiKey&query=$query';
    return _fetchMovies(url);
  }

  // Fungsi untuk mengambil detail film berdasarkan ID
  Future<Movie> getMovieDetails(int movieId) async {
    final String url = '$baseUrl/movie/$movieId?api_key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  // Fungsi umum untuk mengambil data film dari API
  Future<List<Movie>> _fetchMovies(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}
