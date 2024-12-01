import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/detail_movie_screen.dart'; // Import the MovieDetailScreen

class SearchResultsScreen extends StatelessWidget {
  final List<Movie> movies;
  final String query;

  const SearchResultsScreen(
      {super.key, required this.movies, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results: $query'),
      ),
      body: movies.isEmpty
          ? const Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigate to the MovieDetailScreen with the movie id
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(movieId: movies[index].id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: movies[index].posterPath.isNotEmpty
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                                  width: 100,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.movie, size: 40),
                                ),
                        ),
                        const SizedBox(
                            width: 16.0), // Space between image and title
                        Expanded(
                          child: Text(
                            movies[index].title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
