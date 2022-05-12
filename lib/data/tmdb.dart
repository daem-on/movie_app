/// Contains [TMDB], the interface for TheMovieDB's API.
///
/// {@category Data}
library tmdb;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';

/// The interface for TheMovieDB's API.
class TMDB {
  static const String _apiKey = "f48f23f637b002949cbc118f66dc7b63";
  static const String _authority = "api.themoviedb.org:443";

  /// Build the full URL for an image string (a poster or profile picture)
  static String buildImageURL(String path, [int width = 92]) =>
    "https://image.tmdb.org/t/p/w$width/$path";

  /// Gets `/movie/id`
  Future<http.Response> _fetchDetailsById(int id) =>
    http.get(Uri.https(_authority, "/3/movie/$id", {"api_key": _apiKey}));

  /// Gets `/search/movie` or `/search/person` depending on [T]
  Future<http.Response> _search<T>(String query) {
    String urlPart = {Movie: "movie", Person: "person"}[T]!;
    return http.get(Uri.https(_authority, "/3/search/$urlPart", {"api_key": _apiKey, "query": query}));
  }

  /// Gets `/discover/movie`
  Future<http.Response> _discoverMovies(Map<String, dynamic> query) {
    query.addAll({"api_key": _apiKey});
    return http.get(Uri.https(_authority, "/3/discover/movie", query));
  }

  /// Gets `/person/id/movie_credits`
  Future<http.Response> _getCreditsForPerson(int personId) {
    return http.get(Uri.https(_authority, "/3/person/$personId/movie_credits", {"api_key": _apiKey}));
  }

  /// Gets `/movie/id/credits`
  Future<http.Response> _getCreditsForMovie(int movieId) {
    return http.get(Uri.https(_authority, "/3/movie/$movieId/credits", {"api_key": _apiKey}));
  }

  /// Fetch the details of a movie by its TMDB ID.
  Future<Movie> movieFromId(int id) async {
    var response = await _fetchDetailsById(id);
    if (response.statusCode != 200) throw "Fetch details failed";
    var result = jsonDecode(response.body);
    var r = Movie.fromJSON(id, result);
    return r;
  }

  /// Search [Movie]s or [Person]s by a query.
  ///
  /// [T] has to be either [Movie] or [Person]
  Future<List<T>> search<T>(String query) async {
    final construct = {Person: Person.fromJSON, Movie: Movie.fromJSON}[T];
    if (construct == null) throw "Unexpected type $T";

    final response = await _search<T>(query);
    if (response.statusCode != 200) throw "Search failed";
    List<dynamic> list = jsonDecode(response.body)["results"];
    return list.map((e) => construct(e["id"], e) as T).toList();
  }

  /// Uses TMDB discover with a map for the query parameters.
  Future<List<Movie>> discoverMovies(Map<String, dynamic> query) async {
    var response = await _discoverMovies(query);
    // log(response.request!.url.toString());
    if (response.statusCode != 200) throw "Discover failed";
    List<dynamic> list = jsonDecode(response.body)["results"];
    return list.map((e) => Movie.fromJSON(e["id"], e)).toList();
  }

  /// Fetches the filmography of a person by id.
  Future<Filmography> filmography(int personId) async {
    var response = await _getCreditsForPerson(personId);
    if (response.statusCode != 200) throw "Get filmography failed";
    List<dynamic> list1 = jsonDecode(response.body)["cast"];
    List<dynamic> list2 = jsonDecode(response.body)["crew"];
    return Filmography(
      list1.map((e) => MovieCredit.fromJSON(e["id"], e)).toList(),
      list2.map((e) => MovieCredit.fromJSON(e["id"], e)).toList(),
    );
  }

  /// Fetches the credits of a movie by id.
  Future<PersonCredits> movieCredits(int movieId) async {
    var response = await _getCreditsForMovie(movieId);
    if (response.statusCode != 200) throw "Get credits failed";
    List<dynamic> list1 = jsonDecode(response.body)["cast"];
    List<dynamic> list2 = jsonDecode(response.body)["crew"];
    return PersonCredits(
      list1.map((e) => PersonCredit.fromJSON(e["id"], e)).toList(),
      list2.map((e) => PersonCredit.fromJSON(e["id"], e)).toList(),
    );
  }

}

