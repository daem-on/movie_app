import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'model/basic.dart';

class TMDB {
  static const String _apiKey = "f48f23f637b002949cbc118f66dc7b63";
  static const String _authority = "api.themoviedb.org:443";

  static String buildImageURL(String path, [int width = 92]) {
    return "https://image.tmdb.org/t/p/w$width/$path";
  }

  Future<http.Response> _fetchDetailsById(int id) {
    return http.get(Uri.https(_authority, "/3/movie/$id", {"api_key": _apiKey}));
  }

  Future<http.Response> _searchMovies(String query) {
    return http.get(Uri.https(_authority, "/3/search/movie", {"api_key": _apiKey, "query": query}));
  }

  Future<http.Response> _discoverMovies(Map<String, dynamic> query) {
    query.addAll({"api_key": _apiKey});
    return http.get(Uri.https(_authority, "/3/discover/movie", query));
  }

  Future<Movie> movieFromId(int id) async {
    var response = await _fetchDetailsById(id);
    if (response.statusCode != 200) throw "Fetch details failed";
    var result = jsonDecode(response.body);
    var r = Movie.fromJSON(id, result);
    return r;
  }

  Future<List<Movie>> searchMovies(String query) async {
    var response = await _searchMovies(query);
    if (response.statusCode != 200) throw "Search failed";
    List<dynamic> list = jsonDecode(response.body)["results"];
    return list.map((e) => Movie.fromJSON(e["id"], e)).toList();
  }

  Future<List<Movie>> discoverMovies(Map<String, dynamic> query) async {
    var response = await _discoverMovies(query);
    // log(response.request!.url.toString());
    if (response.statusCode != 200) throw "Discover failed";
    List<dynamic> list = jsonDecode(response.body)["results"];
    return list.map((e) => Movie.fromJSON(e["id"], e)).toList();
  }

}

