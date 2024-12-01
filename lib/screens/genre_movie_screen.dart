import 'package:flutter/material.dart';
import 'package:popcornpals/screens/profile_screen.dart';
import '../models/movie.dart';
import '../widgets/custom_navbar.dart';
import 'detail_movie_screen.dart';
import '../utils/api_service.dart'; // Import ApiService untuk memuat genre

class GenreMoviesScreen extends StatefulWidget {
  const GenreMoviesScreen(
      {super.key, required Future<List<Movie>> genreMovies});

  @override
  _GenreMoviesScreenState createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  Future<List<Movie>>? _genreMovies;
  String selectedGenre = 'Action'; // Default genre
  final Map<String, int> genreMap = {
    'Action': 28,
    'Comedy': 35,
    'Drama': 18,
    'Horror': 27,
    'Romance': 10749,
  };

  @override
  void initState() {
    super.initState();
    _loadMoviesForGenre(
        genreMap[selectedGenre]!); // Load movies for default genre
  }

  void _loadMoviesForGenre(int genreId) {
    setState(() {
      _genreMovies = ApiService()
          .getMoviesByGenre(genreId); // Fetch movies based on selected genre
    });
  }

  Widget _buildMovieCard(Movie movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
            const SizedBox(width: 16.0), // Space between image and title
            Expanded(
              child: Text(
                movie.title,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genre Movies'),
        actions: [
          // Dropdown menu for genre selection
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: selectedGenre,
              items: genreMap.keys.map((String genre) {
                return DropdownMenuItem<String>(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedGenre = newValue;
                    _loadMoviesForGenre(genreMap[
                        selectedGenre]!); // Reload movies based on new genre
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _genreMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies available'));
          }

          final movieList = snapshot.data!;
          return ListView.builder(
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(movieList[index]); // Pass movie item here
            },
          );
        },
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
