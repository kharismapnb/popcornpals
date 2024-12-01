import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'detail_movie_screen.dart';
import 'popular_movie_screen.dart';
import 'recommended_movie_screen.dart';
import 'search_result_screen.dart'; // Import the new SearchResultsScreen
import '../utils/api_service.dart';
import '../models/movie.dart'; // Impor model Movie
import '../widgets/custom_navbar.dart';
import 'profile_screen.dart';
import 'genre_movie_screen.dart'; // Import GenreMoviesScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Movie>> _popularMovies = Future.value([]);
  Future<List<Movie>> _recommendedMovies = Future.value([]);
  Future<List<Movie>> _genreMovies = Future.value([]);

  // Gambar untuk carousel
  final List<String> bannerImages = [
    'assets/banner1.jpg',
    'assets/banner2.jpg',
    'assets/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _popularMovies = ApiService().getPopularMovies();
    _recommendedMovies = ApiService().getRecommendedMovies();
    _genreMovies =
        ApiService().getMoviesByGenre(28); // Genre ID untuk Action (misalnya)
  }

  void _searchMovies(String query) {
    setState(() {});
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      height: 160,
                      width: 120,
                    )
                  : Container(
                      height: 160,
                      width: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 80),
                    ),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Future<List<Movie>> movies,
      {bool showSeeAll = false, Widget? seeAllScreen}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (showSeeAll)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            seeAllScreen!, // Pass the corresponding screen
                      ),
                    );
                  },
                  child: const Text('See All'),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Movie>>(
            future: movies,
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
                scrollDirection: Axis.horizontal,
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMovieCard(movieList[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghapus AppBar untuk membuat body dimulai dari atas layar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack untuk menempatkan search bar di atas banner
            Stack(
              children: [
                // Banner dengan Carousel (sebagai background)
                SizedBox(
                  height: 300, // Ukuran banner lebih panjang
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 300.0, // Ubah ukuran tinggi carousel
                      autoPlay: true, // Gambar berubah otomatis
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                    ),
                    // Menggunakan gambar lokal dari folder assets
                    items: [
                      'assets/banner1.jpg',
                      'assets/banner2.jpg',
                      'assets/banner3.jpg',
                    ].map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                // Kolom pencarian yang berada di atas banner
                Positioned(
                  top: 60, // Menurunkan search bar lebih jauh ke bawah
                  left: 16, // Memberi jarak ke kiri
                  right: 16, // Memberi jarak ke kanan
                  child: TextField(
                    onSubmitted: (query) {
                      // Navigate to search results screen with the search query
                      ApiService().searchMovies(query).then((movies) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultsScreen(
                              movies: movies,
                              query: query,
                            ),
                          ),
                        );
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search movies...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Menampilkan sektion film
            _buildSection('Popular Movies', _popularMovies,
                showSeeAll: true,
                seeAllScreen:
                    PopularMoviesScreen(popularMovies: _popularMovies)),
            _buildSection('Recommended Movies', _recommendedMovies,
                showSeeAll: true,
                seeAllScreen: RecommendedMoviesScreen(
                    recommendedMovies: _recommendedMovies)),

            _buildSection('Genre Movies', _genreMovies,
                showSeeAll: true,
                seeAllScreen: GenreMoviesScreen(genreMovies: _genreMovies)),
          ],
        ),
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
