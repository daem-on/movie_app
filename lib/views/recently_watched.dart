part of 'home.dart';

/// A carousel of recently watched movies
///
/// This is the stateful widget part, which handles logic.
/// Gets the list of movie IDs from the [DatabaseManager],
/// looks them up in [TMDB] and shows them in a carousel,
/// which is displayed in a [_RecentlyWatchedCarousel].
class RecentlyWatchedCarousel extends StatefulWidget {
  const RecentlyWatchedCarousel({Key? key}) : super(key: key);

  @override
  State<RecentlyWatchedCarousel> createState() => _RecentlyWatchedCarouselState();
}

class _RecentlyWatchedCarouselState extends State<RecentlyWatchedCarousel> {
  final DatabaseManager _db = DatabaseManager();
  List<Future<Movie>> _futureList = [];
  AsyncSnapshot<List<Movie>> _snapshot = const AsyncSnapshot.waiting();

  /// Called when initialized or on a database update.
  ///
  /// This method loads stored `Future<Movie>`s from the database, translates
  /// each one into a movie by awaiting them, and fills [_snapshot] with the
  /// resulting list of movies.
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _db.initDatabase();
    _futureList = await _db.listEntries();
    if (mounted == false) return;
    if (_futureList.isEmpty) {
      setState(() {
        _snapshot = const AsyncSnapshot.withData(ConnectionState.none, []);
      });
      return;
    }
    final movieList = await Future.wait(_futureList);
    if (mounted == false) return;
    setState(() {
      _snapshot = AsyncSnapshot.withData(ConnectionState.done, movieList);
    });
  }

  /// Callback to add a new movie to recently watched. Opens [Search] and
  /// saves the resulting movie.
  _add() async {
    Movie? movie = await Navigator.of(context).push(Search.route);
    if (movie == null) return;
    await _db.insertEntry(movie);
    didChangeDependencies();
  }

  /// Callback to delete a movie from recently watched.
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

/// Wrapper used to handle contents of the carousel.
/// The first item is special, because it's not a movie, it's a button
/// to add new items.
class _Displayed {
  bool isFirst;
  Movie? movie;

  _Displayed(this.isFirst, this.movie);
}

/// The widget which actually displays movies.
///
/// This is only built when [RecentlyWatchedCarousel] already has
/// the list of movies, which is passed in as [snapshot].
/// All the logic is handled through callbacks passed in the constructor.
class _RecentlyWatchedCarousel extends StatelessWidget {

  const _RecentlyWatchedCarousel(
      this.snapshot,
      this.addCallback,
      this.deleteCallback,
      {Key? key}) : super(key: key);

  final List<Movie> snapshot;
  /// Will be called when the first item (add button) is tapped.
  final Function() addCallback;
  /// Will be called when the remove button on a movie is tapped.
  final Function(Movie movie) deleteCallback;
  /// The list which will get displayed. A first item without a movie is added.
  List<_Displayed> get _list {
    return [_Displayed(true, null)]
        + snapshot.map((e) => _Displayed(false, e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).size.width>MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.only(top: 50),
        child: CarouselSlider(
          options: CarouselOptions(
              height: 400.0,
              viewportFraction: isLandscape ? 0.3 : 0.6,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
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
