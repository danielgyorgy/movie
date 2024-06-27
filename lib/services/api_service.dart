import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';

class ApiService extends ChangeNotifier {
  final String apiKey = 'd30cc88bc0168c4e5a9385783eb9fe3f';
  final String baseUrl = 'https://api.themoviedb.org/3';
  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  ApiService() {
    fetchDefaultMovies();
  }

  Future<void> fetchDefaultMovies() async {
    await searchMovies('');
  }

  Future<void> searchMovies(String query) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cachedMovies');
      if (cachedData != null) {
        final data = json.decode(cachedData);
        final List results = data['results'];
        _movies = results.map((movie) => Movie.fromJson(movie)).toList();
        notifyListeners();
        return;
      }
    }

    final url = query.isEmpty
        ? '$baseUrl/discover/movie?api_key=$apiKey'
        : '$baseUrl/search/movie?api_key=$apiKey&query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      _movies = results.map((movie) => Movie.fromJson(movie)).toList();
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('cachedMovies', json.encode(data));

      notifyListeners();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<MovieDetail> getMovieDetail(int id) async {
    final url = '$baseUrl/movie/$id?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}
