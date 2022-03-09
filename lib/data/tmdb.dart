import 'package:http/http.dart' as http;

class TMDB {
  static const String _apiKey = "f48f23f637b002949cbc118f66dc7b63";
  static const String _authority = "api.themoviedb.org:443";

  Future<http.Response> fetchDetailsById(int id) {
    return http.get(Uri.https(_authority, "/3/movie/$id", {"api_key": _apiKey}));
  }

  static String buildImageURL(String path, [int width = 92]) {
    return "https://image.tmdb.org/t/p/w$width/$path";
  }
}

