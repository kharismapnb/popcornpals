class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double rating;
  final String releaseDate;
  final List<Genre> genres;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Handle null values with fallback defaults
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No Title', // Fallback if title is null
      overview: json['overview'] ??
          'No Overview Available', // Fallback if overview is null
      posterPath: json['poster_path'] ?? '', // Fallback if posterPath is null
      rating: (json['vote_average'] as num?)?.toDouble() ??
          0.0, // Fallback if rating is null
      releaseDate: json['release_date'] ??
          'Unknown Release Date', // Fallback if releaseDate is null
      genres: (json['genres'] as List?)
              ?.map((genreJson) => Genre.fromJson(genreJson))
              .toList() ??
          [], // Fallback if genres is null or empty
    );
  }
}
