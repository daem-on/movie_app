part of 'views.dart';

/// The arguments which will be used to create a `/discover/movie` request
/// to TheMovieDB. The arguments are basically the same as in the
/// TMDB documentation.
class DiscoverArguments {
  /// See `genres` in constants.
  List<int>? genres;
  String? laterThan;
  String? earlierThan;
  /// See `keywords` in constants.
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

  /// Creates a map which can be passed into [TMDB.discoverMovies].
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

/// A view which shows a list of movies based on [DiscoverArguments],
/// which are constraints or filters passed to TheMovieDB. Calls
/// [Navigator.pop] with a [Movie].
///
/// ![Discover](https://github.com/daem-on/movie_app/raw/master/doc_assets/discover.png)
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

/// Due to pagination in TheMovieDB, we have to do multiple requests,
/// which means multiple futures to keep track of.
class _DiscoverState extends State<Discover> {
  var tmdb = TMDB();
  /// List of movies which are displayed.
  final List<Movie> _snapshot = List.empty(growable: true);
  late final DiscoverArguments _args;
  /// Constant size of a page of movies on TMDB.
  static const _pageSize = 20;
  /// A map of which pages we are already loading, by page number.
  final Map<int, bool> _pageLoading = {};

  /// On init, read the arguments into [_args].
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as DiscoverArguments;
  }

  /// When results arrive, write them into [_snapshot].
  void _addResultsToSnapshot(List<Movie> results, int start) {
    if (_snapshot.length > start) log("Overwriting something, $start");
    _snapshot.insertAll(start, results);
  }

  /// Returns an item by its index.
  ///
  /// When the [GridView.builder] requests an item, if it's in [_snapshot],
  /// we can return it. If not, we check if it's already loading, if yes,
  /// we do nothing, if not, we start loading its whole page.
  ///
  /// Returns null while loading (or if it failed) and a [Movie] if loaded.
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

  /// The build function for [GridView.builder].
  ///
  /// Builds a movie poster if loaded, otherwise a loading indicator.
  Widget _buildChildren(BuildContext context, int place) {
    final value = _getAtPlace(place);
    if (value != null) {
      return _MoviePosterTitle(value);
    } else {
      return const Center(child: CupertinoActivityIndicator());
    }
  }
}

