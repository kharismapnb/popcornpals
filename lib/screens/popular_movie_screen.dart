import 'package:flutter/material.dart';
import 'package:popcornpals/screens/profile_screen.dart';
import '../models/movie.dart';
import '../widgets/custom_navbar.dart';
import 'detail_movie_screen.dart';

class PopularMoviesScreen extends StatelessWidget {
  final Future<List<Movie>> popularMovies;

  const PopularMoviesScreen({super.key, required this.popularMovies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: popularMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No popular movies available'));
          }

          final movieList = snapshot.data!;
          return ListView.builder(
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Navigate to the MovieDetailScreen with the movie id
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movieList[index].id),
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
                        child: movieList[index].posterPath.isNotEmpty
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${movieList[index].posterPath}',
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
                          movieList[index].title,
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
