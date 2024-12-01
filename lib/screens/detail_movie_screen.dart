import 'package:flutter/material.dart';
import '../utils/api_service.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieDetails;

  @override
  void initState() {
    super.initState();
    _movieDetails = ApiService().getMovieDetails(
        widget.movieId); // Mendapatkan detail film berdasarkan ID
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xff3442af);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: FutureBuilder<Movie>(
        future: _movieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No details available'));
          }

          final movie = snapshot.data!;

          // Extract additional details from the API response (e.g., genres and release year)
          final releaseYear =
              movie.releaseDate.split('-')[0]; // Extract year from release date
          final genreList = movie.genres.map((genre) => genre.name).join(', ');

          // Format rating to show one decimal place
          final formattedRating = movie.rating.toStringAsFixed(1);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Poster Image with BoxFit.contain to avoid cropping
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit
                        .contain, // Ensure the image fits without cropping
                    width: double.infinity,
                    height:
                        400, // Optional: You can adjust the height to maintain aspect ratio
                  ),
                ),
                const SizedBox(height: 16),
                // Movie Title
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Release Year and Rating in Row with Boxes
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Release: $releaseYear',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Rating: $formattedRating',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Genre (below Release and Rating)
                Text(
                  'Genres: $genreList',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16),
                // Synopsis (overview) - Justified Text
                SingleChildScrollView(
                  // Make the overview scrollable
                  child: Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify, // Makes synopsis justified
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
