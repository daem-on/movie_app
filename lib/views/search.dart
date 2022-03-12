import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/common.dart';

import '../data/tmdb.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  static Route<Movie> get route => CupertinoPageRoute(
      builder: (context) => const Search(),
      title: "Search"
  );

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var tmdb = TMDB();
  Future<List<Movie>>? _cachedFuture;

  @override
  void initState() {
    super.initState();
    // _cachedFuture = tmdb.searchMovies("Spider-Man");
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      title: "Search",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CupertinoSearchTextField(
              autofocus: true,
              onSubmitted: (value) => setState(() {
                _cachedFuture = tmdb.searchMovies(value);
              }),
            ),
          ),
          Expanded(
            child: CupertinoContainer(
              child: (_cachedFuture != null) ? FutureBuilder(
                future: _cachedFuture,
                builder: (context, AsyncSnapshot<List<Movie>> snapshot) => GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 9 / 16,
                      crossAxisSpacing: 5,
                    ),
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: _buildChildren(snapshot),
                ),
              ) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget Function(BuildContext, int) _buildChildren(
      AsyncSnapshot<List<Movie>> snapshot) {
    return (context, i) {
      return snapshot.hasData
          ? MoviePosterTitle(snapshot.data![i])
          : const Placeholder();
    };
  }
}

class MoviePosterTitle extends StatelessWidget {
  final Movie movie;

  const MoviePosterTitle(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: movie.fullTitle,
      child: GestureDetector(
        onTap: () => {
          Navigator.of(context).pop(movie)
        },
        child: (movie.poster != null)
          ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                TMDB.buildImageURL(movie.poster!, 154),
                width: 154,
              ),
            ),
          )
          : Center(
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                color: CupertinoColors.tertiarySystemGroupedBackground,
                child: const Center(child: Text("No image")),
              ),
            ),
          ),
      ),
    );
  }
}
