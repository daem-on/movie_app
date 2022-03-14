import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/views/discover.dart';
import 'package:movie_app/views/search.dart';

import '../data/model/basic.dart';
import 'common.dart';

class ToplistView extends StatefulWidget {
  const ToplistView({Key? key}) : super(key: key);

  @override
  State<ToplistView> createState() => _ToplistViewState();
}

class ToplistTemplate {
  DiscoverArguments settings;
  String title;
  ToplistTemplate(this.title, this.settings);
}

class _ToplistViewState extends State<ToplistView> {
  final List<Movie> _list = List.empty(growable: true);
  DiscoverArguments _settings = DiscoverArguments();
  final List<ToplistTemplate> _templates = [
    ToplistTemplate("90's comedies", DiscoverArguments(genres: [35], laterThan: "1990-01-01", earlierThan: "1999-12-31")),
    ToplistTemplate("Superhero movies", DiscoverArguments(keywords: [9715])),
    ToplistTemplate("Horror movies", DiscoverArguments(genres: [27])),
    ToplistTemplate("Japanese language movies", DiscoverArguments(originalLang: "ja")),
  ];

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
        Discover.route(_settings)
    );
    if (movie == null) return;
    setState(() {
      _list.add(movie);
    });
  }

  void loadTemplate(ToplistTemplate template) {
    setState(() {
      _settings = template.settings;
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
    Map<int, String> backwards = genres.map((key, value) => MapEntry(value, key));
    if (_settings.genre != null) {
      return "Selected: " + backwards[_settings.genre]!;
    }
    return null;
  }

  String? get _selectedKeywordText {
    Map<int, String> backwards = keywords.map((key, value) => MapEntry(value, key));
    if (_settings.keyword != null) {
      return "Selected: " + backwards[_settings.keyword]!;
    }
    return null;
  }

  String? get _selectedLangText {
    Map<String, String> backwards = languages.map((key, value) => MapEntry(value, key));
    if (_settings.originalLang != null) {
      return "Selected: " + backwards[_settings.originalLang]!;
    }
    return null;
  }

  void _chooseGenre() async {
    final init = _getInitialIndex(_valuesFrom(genres), _settings.genre);
    final index = await _showPickerModal(_optionsFrom(genres), init);
    if (index == null) return;

    if (index == 0) {
      setState(() {_settings.genre = null;});
    } else {
      setState(() {_settings.genre = _valuesFrom(genres)[index];});
    }
  }

  void _chooseKeyword() async {
    final init = _getInitialIndex<int>(_valuesFrom(keywords), _settings.keyword);
    final index = await _showPickerModal(_optionsFrom(keywords), init);
    if (index == null) return;

    if (index == 0) {
      setState(() {_settings.keyword = null;});
    } else {
      setState(() {_settings.keyword = _valuesFrom(keywords)[index];});
    }
  }

  void _chooseLang() async {
    final values = ["", ...languages.values];
    final init = _getInitialIndex(values, _settings.originalLang);
    final index = await _showPickerModal(_optionsFrom(languages), init);
    if (index == null) return;

    if (index == 0) {
      setState(() {_settings.originalLang = null;});
    } else {
      setState(() {_settings.originalLang = values[index];});
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
      title: "Toplist",
      child: Column(
        children: [
          Expanded(
            child: CupertinoContainer(
              child: ListView(
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
                    secondText: (_settings.laterThan != null) ? "Selected: ${_settings.laterThan}" : null,
                    onPressed: () async {
                      final date = await _chooseDate(_settings.laterThan);
                      setState(() {_settings.laterThan = date;});
                    },
                  ),
                  SettingRow(
                    text: "Released earlier than",
                    secondText: (_settings.earlierThan != null) ? "Selected: ${_settings.earlierThan}" : null,
                    onPressed: () async {
                      final date = await _chooseDate(_settings.earlierThan);
                      setState(() {_settings.earlierThan = date;});
                    },
                  ),
                  SettingRow(
                    text: "Restrict to shorter than",
                    secondText: (_settings.shorterThan != null) ? "Selected: ${_settings.shorterThan} min" : null,
                    onPressed: () async {
                      final dur = await _chooseDuration(_settings.shorterThan);
                      setState(() {_settings.shorterThan = dur;});
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




