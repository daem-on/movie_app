import 'dart:developer';

import 'package:flutter/cupertino.dart';
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

  int? get genre => genres?[0];
  int? get keyword => keywords?[0];

  set genre(int? v) => genres = (v == null) ? null : [v];
  set keyword(int? v) => keywords = (v == null) ? null : [v];

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

  static Route<Movie> route(DiscoverArguments args) => CupertinoPageRoute(
      builder: (context) => const Discover(),
      title: "Discover",
      settings: RouteSettings(arguments: args)
  );

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  var tmdb = TMDB();
  final List<Movie> _snapshot = List.empty(growable: true);
  late final DiscoverArguments _args;
  static const _pageSize = 20;
  final Map<int, bool> _pageLoading = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as DiscoverArguments;
  }
  
  void _addResultsToSnapshot(List<Movie> results, int start) {
    if (_snapshot.length > start) log("Overwriting something, $start");
    _snapshot.insertAll(start, results);
  }
  
  Movie? _getAtPlace(int place) {
    if (_snapshot.length <= place) {
      final page = (place / _pageSize).truncate()+1;
      // we are already loading this page
      if (_pageLoading[page] ?? false) return null;

      final paginated = _args.toMap();
      paginated.addAll({"page": "$page"});
      final future = tmdb.discoverMovies(paginated);
      _pageLoading[page] = true;

      future.then(
        (value) => setState(() {
          _addResultsToSnapshot(value, (page-1)*_pageSize);
        })
      );
      return null;
    } else {
      return _snapshot[place];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      title: "Discover",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 9 / 16,
              crossAxisSpacing: 5,
            ),
            itemCount: 100,
            itemBuilder: _buildChildren
        ),
      )
    );
  }

  Widget _buildChildren(BuildContext context, int place) {
    final value = _getAtPlace(place);
    if (value != null) {
      return MoviePosterTitle(value);
    } else {
      return const Center(child: CupertinoActivityIndicator());
    }
  }
}

