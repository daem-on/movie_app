import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/testHomePage.dart';
import 'package:movie_app/views/search.dart';

import 'data/database.dart';
import 'data/model/basic.dart';
import 'data/tmdb.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemPink
      ),
      home: Search(),
    );
  }
}

class MovieInfoTest extends StatefulWidget {
  final int movieId;

  const MovieInfoTest({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieInfoTest> createState() => _MovieInfoTestState(movieId);
}

class _MovieInfoTestState extends State<MovieInfoTest> {
  _MovieInfoTestState(this.movieId);

  late Future<Movie> _cachedFuture;
  int movieId;

  @override
  void initState() {
    super.initState();

    // final db = DatabaseManager();
    final tmdb = TMDB();
    _cachedFuture = tmdb.movieFromId(movieId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cachedFuture,
      builder: (context, AsyncSnapshot<Movie> snapshot) =>
        (!snapshot.hasData) ? const CupertinoActivityIndicator() :
        Column(
          children: [
            if (snapshot.data?.poster != null) Image.network(
                TMDB.buildImageURL(snapshot.data!.poster!)
            ),
            Text(snapshot.data?.fullTitle ?? "None yet"),
          ],
        ),
    );
  }
}

class MovieTitleMarquee extends StatelessWidget {
  final String title;

  const MovieTitleMarquee({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: Marquee(
        pauseAfterRound: const Duration(seconds: 1),
        blankSpace: 10,
        fadingEdgeStartFraction: 0,
        startPadding: 10,
        fadingEdgeEndFraction: 0.3,
        text: title
      )
    );
  }
}

