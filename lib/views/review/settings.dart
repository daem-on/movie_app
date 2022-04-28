part of "review.dart";

class ReviewSettingsView extends StatefulWidget {
  const ReviewSettingsView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const ReviewSettingsView(),
      title: "Review"
  );

  static Route routeWithMove(Movie movie) => CupertinoPageRoute(
      builder: (context) => const ReviewSettingsView(),
      title: "Review",
      settings: RouteSettings(arguments: movie)
  );

  @override
  State<ReviewSettingsView> createState() => _ReviewSettingsViewState();
}

class ReviewSettings {
  String title = "";
  String textReview = "";
  String username = "";
  Movie? movie;
  int overallRating = 5;
  int alignText = 0;
  List<RatedItem<PersonCredit>> people = [];
  List<Aspect> aspects = [];
  bool showUsername = true;
  bool showPosters = true;
  bool useNumbers = false;
}

class _ReviewSettingsViewState extends State<ReviewSettingsView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args.runtimeType == Movie) _settings.movie = args as Movie;
    _loadCredits();
  }

  final ReviewSettings _settings = ReviewSettings();
  final _tmdb = TMDB();
  static const _aspects = [
    "Editing", "Set design", "Cinematography", "Lighting",
    "Visual effects", "Special effects"
  ];

  get _movieChosen => _settings.movie != null;
  PersonCredits? _credits;

  void _chooseMovie() async {
    final result = await Navigator.of(context).push(Search.route);
    if (result == null) return;
    setState(() { _settings.movie = result; });
    _loadCredits();
  }

  void _loadCredits() async {
    if (_settings.movie == null) return;
    _credits = await _tmdb.movieCredits(_settings.movie!.id);
  }

  void _addCredit() async {
    if (_credits == null) return;
    final result = await Navigator.of(context).push(SelectCredit.route(_credits!));
    if (result != null) {
      setState(() {
        _settings.people.add(RatedItem(result, 5));
      });
    }
  }

  void _addAspect() async {
    final index = await showCupertinoModalPopup(
        context: context,
        semanticsDismissible: true,
        builder: (context) => PickerModal(options: _aspects, button: "Add",)
    );
    if (index == null) return;
    setState(() {
      _settings.aspects.add(RatedItem(_aspects[index], 5));
    });
  }

  List<Widget> _partRatings() {
    return [
      for (final element in _settings.people)
        _partRating(
            "${element.item.name} (${element.item.job ?? element.item.character})",
            element
        ),
      for (final element in _settings.aspects)
        _partRating(element.item, element),
    ];
  }

  Widget _partRating(String text, RatedItem element) {
    return Dismissible(
      key: ValueKey(element),
      child: Column(
        children: [
          Text(text),
          NonNullStarRatingSlider(
              rating: element.rating,
              callback: (rating) {
                setState(() {element.rating = rating;});
              }
          )
        ],
      ),
      onDismissed: (dir) {
        setState(() {
          _settings.aspects.remove(element);
          _settings.people.remove(element);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: (!_movieChosen) ? null :
      TrailingButton(
        onPressed: () {
          Navigator.of(context).push(ReviewAppearanceView.route(_settings));
        },
        text: "Appearance",
      ),
      child: Column(
        children: [
          CupertinoContainer(
            child: SettingRow(
              text: "Choose movie",
              secondText: _settings.movie!=null ? "Current: ${_settings.movie?.fullTitle}" : null,
              onPressed: _chooseMovie,
            )
          ),
          if (_movieChosen) Expanded(
            child: Column(
              children: [
                CupertinoContainer(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Your overall rating"),
                      ),
                      NonNullStarRatingSlider(
                          rating: _settings.overallRating,
                          callback: (rating) {
                            setState(() {_settings.overallRating = rating;});
                          }
                      ),
                      SettingRow(
                        text: "Add rating for person",
                        onPressed: _addCredit,
                        icon: const Icon(CupertinoIcons.add),
                      ),
                      SettingRow(
                        text: "Add rating for aspect",
                        onPressed: _addAspect,
                        icon: const Icon(CupertinoIcons.add),
                      )
                    ],
                  )
                ),
                Expanded(
                  child: CupertinoContainer(
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: _partRatings(),
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}




