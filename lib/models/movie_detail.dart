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

class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final String status;
  final double popularity;
  final String originalLanguage;
  final double voteAverage;
  final List<Genre> genres;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.status,
    required this.popularity,
    required this.originalLanguage,
    required this.voteAverage,
    required this.genres,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'],
      status: json['status'],
      popularity: (json['popularity'] as num).toDouble(),
      originalLanguage: json['original_language'],
      voteAverage: (json['vote_average'] as num).toDouble().roundToDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }
}
