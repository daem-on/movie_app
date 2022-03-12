import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/search.dart';

import '../data/tmdb.dart';

class DiscoverArguments {
  List<int>? genres;
  String? laterThan;
  String? earlierThan;
  List<int>? keywords;
  String? originalLang;
  int? shorterThan;
  int? longerThan;

  DiscoverArguments({
    this.genres,
    this.laterThan,
    this.earlierThan,
    this.keywords,
    this.originalLang,
    this.shorterThan,
    this.longerThan
  });

  Map<String, dynamic> toMap() {
    return {
      if (genres != null) "with_genres" : genres!.join(","),
      if (keywords != null) "with_keywords" : keywords!.join(","),
      if (laterThan != null) "primary_release_date.gte" : laterThan,
      if (earlierThan != null) "primary_release_date.lte" : earlierThan,
      if (originalLang != null) "with_original_language" : originalLang,
      if (shorterThan != null) "with_runtime.lte" : shorterThan,
      if (longerThan != null) "with_runtime.gte" : longerThan,
    };
  }
}

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  var tmdb = TMDB();
  late Future<List<Movie>> _cachedFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as DiscoverArguments;
    _cachedFuture = tmdb.discoverMovies(args.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      title: "Discover",
      child: Column(
        children: [
          Expanded(
            child: CupertinoContainer(
              child: FutureBuilder(
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
              ),
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

