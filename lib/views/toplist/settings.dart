part of "toplist.dart";

class ToplistSettingsView extends StatefulWidget {
  const ToplistSettingsView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const ToplistSettingsView(),
      title: "Toplist"
  );

  @override
  State<ToplistSettingsView> createState() => _ToplistSettingsViewState();
}

class ToplistTemplate {
  DiscoverArguments arguments;
  String title;
  ToplistTemplate(this.title, this.arguments);
}

class ToplistSettings {
  DiscoverArguments arguments = DiscoverArguments();
  String title = "";
  String username = "";
  bool showUsername = true;
  bool useMovieBackdrop = true;
  bool showPosters = true;
  bool lightColors = false;
  bool dynamicColor = false;
  final List<Movie> list = List.empty(growable: true);
  LookPreset preset = lookPresets["Cinema seats"]!;

  loadTemplate(ToplistTemplate template) {
    title = template.title; arguments = template.arguments;
  }
}

class _ToplistSettingsViewState extends State<ToplistSettingsView> {
  final ToplistSettings _settings = ToplistSettings();
  final List<ToplistTemplate> _templates = [
    ToplistTemplate("90's comedies", DiscoverArguments(genres: [35], laterThan: "1990-01-01", earlierThan: "1999-12-31")),
    ToplistTemplate("Superhero movies", DiscoverArguments(keywords: [9715])),
    ToplistTemplate("Horror movies", DiscoverArguments(genres: [27])),
    ToplistTemplate("Japanese language movies", DiscoverArguments(originalLang: "ja")),
  ];
  DiscoverArguments get _args => _settings.arguments;
  List<Movie> get _list => _settings.list;

  List<String> _optionsFrom(Map<String, dynamic> map) => ["None", ...map.keys];
  List<int> _valuesFrom(Map<String, int> map) => [0, ...map.values];

  int _getInitialIndex<T>(List<T> list, T? val) {
    if (val == null) return 0;
    return list.indexOf(val);
  }

  void _gotoSearchAddMovie() async {
    Movie? movie = await Navigator.of(context).push(Search.route);
    if (movie == null) return;
    setState(() {
      _list.add(movie);
    });
  }

  void _gotoDiscoverAddMovie() async {
    Movie? movie = await Navigator.of(context).push(
        Discover.route(_args)
    );
    if (movie == null) return;
    setState(() {
      _list.add(movie);
    });
  }

  void loadTemplate(ToplistTemplate template) {
    setState(() {
      _settings.loadTemplate(template);
    });
  }

  Future<int?> _showPickerModal(List<String> options, [int? initialItem]) {
    return showCupertinoModalPopup(
        context: context,
        semanticsDismissible: true,
        builder: (context) => PickerModal(options: options, initialItem: initialItem,)
    );
  }

  void _chooseTemplate() async {
    final List<String> names = _templates.map((e) => e.title).toList();
    final index = await _showPickerModal(names);
    if (index == null) return;

    loadTemplate(_templates[index]);
  }

  String? get _selectedGenreText {
    if (_args.genre != null) {
      return "Selected: " + _genreLookup[_args.genre]!;
    }
    return null;
  }

  String? get _selectedKeywordText {
    if (_args.keyword != null) {
      return "Selected: " + _keywordLookup[_args.keyword]!;
    }
    return null;
  }

  String? get _selectedLangText {
    if (_args.originalLang != null) {
      return "Selected: " + _langLookup[_args.originalLang]!;
    }
    return null;
  }

  void _chooseGenre() async {
    final init = _getInitialIndex(_valuesFrom(genres), _args.genre);
    final index = await _showPickerModal(_optionsFrom(genres), init);
    if (index == null) return;

    if (index == 0) {
      setState(() {_args.genre = null;});
    } else {
      setState(() {_args.genre = _valuesFrom(genres)[index];});
    }
  }

  void _chooseKeyword() async {
    final init = _getInitialIndex<int>(_valuesFrom(keywords), _args.keyword);
    final index = await _showPickerModal(_optionsFrom(keywords), init);
    if (index == null) return;

    if (index == 0) {
      setState(() {_args.keyword = null;});
    } else {
      setState(() {_args.keyword = _valuesFrom(keywords)[index];});
    }
  }

  void _chooseLang() async {
    final values = ["", ...languages.values];
    final init = _getInitialIndex(values, _args.originalLang);
    final index = await _showPickerModal(_optionsFrom(languages), init);
    if (index == null) return;

    if (index == 0) {
      setState(() {_args.originalLang = null;});
    } else {
      setState(() {_args.originalLang = values[index];});
    }
  }

  Future<String?> _chooseDate(String? original) async {
    var result = await showCupertinoModalPopup<Result<dynamic>>(
        context: context,
        semanticsDismissible: true,
        builder: (context) => DateModal()
    );
    if (result == null) return original;
    if (result.hasValue) return result.value!.toIso8601String().substring(0, 10);
    return null;
  }

  Future<int?> _chooseDuration(int? initial) async {
    var result = await showCupertinoModalPopup<Result<dynamic>>(
        context: context,
        semanticsDismissible: true,
        builder: (context) => DurationModal(
            value: Duration(minutes: initial ?? 60)
        )
    );
    if (result == null) return initial;
    if (result.hasValue) return result.value!.inMinutes;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: TrailingButton(
        onPressed: () {
          Navigator.of(context).push(ToplistAppearanceView.route(_settings));
        },
        text: "Appearance",
      ),
      child: Column(
        children: [
          Expanded(
            child: CupertinoContainer(
              child: ListView(
                controller: ScrollController(),
                padding: EdgeInsets.zero,
                children: [
                  SettingRow(
                    text: "Start with a template",
                    onPressed: _chooseTemplate,
                  ),
                  SettingRow(
                    text: "Add specific movie",
                    onPressed: _gotoSearchAddMovie,
                    icon: const Icon(CupertinoIcons.search),
                  ),
                  SettingRow(
                    text: "Discover movies",
                    secondText: "Based on restrictions",
                    onPressed: _gotoDiscoverAddMovie,
                    icon: const Icon(CupertinoIcons.compass),
                  ),
                  SettingRow(
                    text: "Restrict to genre",
                    secondText: _selectedGenreText,
                    onPressed: _chooseGenre,
                  ),
                  SettingRow(
                    text: "Restrict to keyword",
                    secondText: _selectedKeywordText,
                    onPressed: _chooseKeyword,
                  ),
                  SettingRow(
                    text: "Released later than",
                    secondText: (_args.laterThan != null) ? "Selected: ${_args.laterThan}" : null,
                    onPressed: () async {
                      final date = await _chooseDate(_args.laterThan);
                      setState(() {_args.laterThan = date;});
                    },
                  ),
                  SettingRow(
                    text: "Released earlier than",
                    secondText: (_args.earlierThan != null) ? "Selected: ${_args.earlierThan}" : null,
                    onPressed: () async {
                      final date = await _chooseDate(_args.earlierThan);
                      setState(() {_args.earlierThan = date;});
                    },
                  ),
                  SettingRow(
                    text: "Restrict to shorter than",
                    secondText: (_args.shorterThan != null) ? "Selected: ${_args.shorterThan} min" : null,
                    onPressed: () async {
                      final dur = await _chooseDuration(_args.shorterThan);
                      setState(() {_args.shorterThan = dur;});
                    },
                  ),
                  SettingRow(
                    text: "Restrict to original language",
                    secondText: _selectedLangText,
                    onPressed: _chooseLang,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CupertinoContainer(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ReorderableListView(
                children: [
                  for (var movie in _list)
                    Dismissible(
                      onDismissed: (direction) => setState(() {_list.remove(movie);}),
                      background: Container(
                          color: CupertinoColors.destructiveRed,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(CupertinoIcons.delete, color: Colors.white,),
                          ),
                          alignment: Alignment.centerRight),
                      key: Key(movie.id.toString()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(children: [Flexible(child: Text(movie.fullTitle, overflow: TextOverflow.ellipsis))],)
                      ),
                    )
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final Movie item = _list.removeAt(oldIndex);
                    _list.insert(newIndex, item);
                  });
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}




