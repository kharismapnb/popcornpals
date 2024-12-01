import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          movie.posterPath.isNotEmpty
              ? Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 200,
                  color: Colors.grey,
                  child: const Center(child: Text('No Image')),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
