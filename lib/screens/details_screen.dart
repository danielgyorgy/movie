import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_detail.dart';
import '../services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final int movieId;

  DetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Makes the AppBar background extend into the body
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background for the AppBar
        elevation: 0, // No shadow under the AppBar
      ),
      body: FutureBuilder<MovieDetail>(
        // Fetches movie details asynchronously
        future: Provider.of<ApiService>(context, listen: false).getMovieDetail(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs during data fetching, display the error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // If no data is available, display a message indicating no data
            return const Center(child: Text('No data'));
          } else {
            // Once data is loaded successfully, display the movie details
            final movie = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: 'moviePoster${movie.id}', // Unique tag for Hero animation
                        child: _buildBackgroundImage(movie, context), // Background image of the movie
                      ),
                      _buildGradientOverlay(context), // Gradient overlay for the background image
                      _buildMovieDetails(movie), // Movie details overlay
                    ],
                  ),
                  _buildMovieOverview(movie), // Detailed overview of the movie
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Builds the background image of the movie
  Widget _buildBackgroundImage(MovieDetail movie, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      child: movie.posterPath != null
          ? CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/movie.png', fit: BoxFit.cover),
              fit: BoxFit.cover,
            )
          : Image.asset('assets/images/movie.png', fit: BoxFit.cover),
    );
  }

  // Builds a gradient overlay for the background image
  Widget _buildGradientOverlay(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
        ),
      ),
    );
  }

  // Builds the details of the movie (title, rating)
  Widget _buildMovieDetails(MovieDetail movie) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.yellow, size: 20),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builds the detailed overview of the movie (status, popularity, language, genres)
  Widget _buildMovieOverview(MovieDetail movie) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Status', movie.status),
              _buildDetailItem('Popularity', movie.popularity.toString()),
              _buildDetailItem('Language', movie.originalLanguage.toUpperCase()),
            ],
          ),
          const Divider(color: Colors.grey),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: movie.genres.map((genre) {
              return Chip(
                label: Text(
                  genre.name,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            movie.overview,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Builds a single detail item (e.g., Status: Released)
  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
