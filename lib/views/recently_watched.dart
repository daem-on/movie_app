import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_app/data/database.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/review/settings.dart';
import 'package:movie_app/views/search.dart';

import '../data/model/basic.dart';
import '../data/tmdb.dart';

class RecentlyWatchedCarousel extends StatefulWidget {
  const RecentlyWatchedCarousel({Key? key}) : super(key: key);

  @override
  State<RecentlyWatchedCarousel> createState() => _RecentlyWatchedCarouselState();
}

class _RecentlyWatchedCarouselState extends State<RecentlyWatchedCarousel> {
  final DatabaseManager _db = DatabaseManager();
  List<Future<Movie>> _futureList = [];
  AsyncSnapshot<List<Movie>> _snapshot = const AsyncSnapshot.waiting();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _db.initDatabase();
    _futureList = await _db.listEntries();
    if (_futureList.isEmpty) {
      setState(() {
        _snapshot = const AsyncSnapshot.withData(ConnectionState.none, []);
      });
      return;
    }
    final movieList = await Future.wait(_futureList);
    setState(() {
      _snapshot = AsyncSnapshot.withData(ConnectionState.done, movieList);
    });
  }

  _add() async {
    Movie? movie = await Navigator.of(context).push(Search.route);
    if (movie == null) return;
    await _db.insertEntry(movie);
    didChangeDependencies();
  }

  _delete(Movie movie) async {
    await _db.removeEntryById(movie.id);
    didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _snapshot.hasData
      ? _RecentlyWatchedCarousel(_snapshot.data!, _add, _delete)
      : const CupertinoActivityIndicator();
  }
}

class _Displayed {
  bool isFirst;
  Movie? movie;

  _Displayed(this.isFirst, this.movie);
}

class _RecentlyWatchedCarousel extends StatelessWidget {

  const _RecentlyWatchedCarousel(
      this.snapshot,
      this.addCallback,
      this.deleteCallback,
      {Key? key}) : super(key: key);

  final List<Movie> snapshot;
  final Function() addCallback;
  final Function(Movie movie) deleteCallback;
  List<_Displayed> get _list {
    return [_Displayed(true, null)]
        + snapshot.map((e) => _Displayed(false, e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 50),
        child: CarouselSlider(
          options: CarouselOptions(
              height: 400.0,
              enableInfiniteScroll: false,
              initialPage: 1,
              enlargeCenterPage: true
          ),
          items: [for (final item in _list)
            item.isFirst ? Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: CupertinoColors.systemYellow,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Center(
                child: CupertinoButton(
                  onPressed: addCallback,
                  child: const Text("+", style: TextStyle(fontSize: 30)),
                )
              )
            ) : Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  MoviePosterSimple(item.movie!, width: null, posterWidth: 500, placeholderText: true),
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton.filled(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.pen),
                            onPressed: () {
                              Navigator.of(context).push(ReviewSettingsView.routeWithMove(item.movie!));
                            }
                        ),
                        const SizedBox(width: 16),
                        CupertinoButton.filled(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.clear),
                            onPressed: () {deleteCallback(item.movie!);}
                        ),
                      ],
                    ),
                    left: 0,
                    right: 0,
                    bottom: 10,
                  )
                ],
              )
            )
          ],
        )
    );
  }
}
