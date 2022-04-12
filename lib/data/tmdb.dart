import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/basic.dart';

class TMDB {
  static const String _apiKey = "f48f23f637b002949cbc118f66dc7b63";
  static const String _authority = "api.themoviedb.org:443";

  static String buildImageURL(String path, [int width = 92]) =>
    "https://image.tmdb.org/t/p/w$width/$path";

  Future<http.Response> _fetchDetailsById(int id) =>
    http.get(Uri.https(_authority, "/3/movie/$id", {"api_key": _apiKey}));

  Future<http.Response> _search<T>(String query) {
    String urlPart = {Movie: "movie", Person: "person"}[T]!;
    return http.get(Uri.https(_authority, "/3/search/$urlPart", {"api_key": _apiKey, "query": query}));
  }

  Future<http.Response> _discoverMovies(Map<String, dynamic> query) {
    query.addAll({"api_key": _apiKey});
    return http.get(Uri.https(_authority, "/3/discover/movie", query));
  }

  Future<http.Response> _movieCredits(int personId) {
    return http.get(Uri.https(_authority, "/3/person/$personId/movie_credits", {"api_key": _apiKey}));
  }

  Future<Movie> movieFromId(int id) async {
    var response = await _fetchDetailsById(id);
    if (response.statusCode != 200) throw "Fetch details failed";
    var result = jsonDecode(response.body);
    var r = Movie.fromJSON(id, result);
    return r;
  }

  Future<List<T>> search<T>(String query) async {
    final construct = {Person: Person.fromJSON, Movie: Movie.fromJSON}[T];
    if (construct == null) throw "Unexpected type $T";

    final response = await _search<T>(query);
    if (response.statusCode != 200) throw "Search failed";
    List<dynamic> list = jsonDecode(response.body)["results"];
    return list.map((e) => construct(e["id"], e) as T).toList();
  }

  Future<List<Movie>> discoverMovies(Map<String, dynamic> query) async {
    var response = await _discoverMovies(query);
    // log(response.request!.url.toString());
    if (response.statusCode != 200) throw "Discover failed";
    List<dynamic> list = jsonDecode(response.body)["results"];
    return list.map((e) => Movie.fromJSON(e["id"], e)).toList();
  }

  Future<Filmography> filmography(int personId) async {
    var response = await _movieCredits(personId);
    if (response.statusCode != 200) throw "Get filmography failed";
    List<dynamic> list1 = jsonDecode(response.body)["cast"];
    List<dynamic> list2 = jsonDecode(response.body)["crew"];
    return Filmography(
      list1.map((e) => MovieCredit.fromJSON(e["id"], e)).toList(),
      list2.map((e) => MovieCredit.fromJSON(e["id"], e)).toList(),
    );
  }

}

