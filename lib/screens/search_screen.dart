import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import 'details_screen.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for the scaffold
      appBar: AppBar(
        elevation: 0, // No shadow under the app bar
        title: const Text(
          'Movies',
          style: TextStyle(
            color: Colors.black, // Black color for text
            fontWeight: FontWeight.bold, // Bold font weight
          ),
        ),
        centerTitle: true, // Center align title
        backgroundColor: Colors.white, // White background color for app bar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              placeholder: 'Search', // Placeholder text
              prefix: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search), // Search icon as prefix
              ),
              onChanged: (value) {
                Provider.of<ApiService>(context, listen: false).searchMovies(value); // Calling searchMovies method from ApiService on text change
              },
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color (optional)
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
            ),
          ),
          Expanded(
            child: Consumer<ApiService>(
              builder: (context, apiService, child) {
                return ListView.builder(
                  itemCount: apiService.movies.length,
                  itemBuilder: (context, index) {
                    final movie = apiService.movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(movieId: movie.id), // Navigate to DetailScreen with movie ID
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Card margins
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Rounded corners for card
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 140, // Card height
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: 'moviePoster${movie.id}', // Unique tag for each movie poster
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}', // Movie poster URL
                                      width: 100,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/movie.png', // Placeholder image asset
                                          width: 100,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title, // Movie title
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.yellow, size: 20), // Star icon for rating
                                          const SizedBox(width: 4),
                                          Text(
                                            movie.voteAverage.toStringAsFixed(1), // Movie rating
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.favorite, color: Colors.red, size: 20), // Heart icon for vote count
                                          const SizedBox(width: 4),
                                          Text(
                                            movie.voteCount.toString(), // Vote count
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Text(
                                          movie.overview, // Movie overview
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
