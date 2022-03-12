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

  void _chooseTemplate() async {
    final List<String> names = _templates.map((e) => e.title).toList();
    var index = await showCupertinoModalPopup<int?>(
        context: context,
        semanticsDismissible: true,
        builder: (context) => PickerModal(options: names)
    );
    if (index == null) return;

    loadTemplate(_templates[index]);
  }

  String? _getSelectedGenre() {
    Map<int, String> backwards = genres.map((key, value) => MapEntry(value, key));
    if (_settings.genres != null) {
      return backwards[_settings.genres![0]];
    }
    return null;
  }

  void _chooseGenre() async {
    final List<String> names = genres.entries.map((e) => e.key).toList();
    final List<int> values = genres.entries.map((e) => e.value).toList();
    int initialIndex =
    (_settings.genres != null) ? values.indexOf(_settings.genres![0]) : 0;
    var index = await showCupertinoModalPopup<int?>(
        context: context,
        semanticsDismissible: true,
        builder: (context) => PickerModal(
          options: names,
          initialItem: initialIndex,
        )
    );
    if (index == null) return;

    setState(() {
      _settings.genres = [values[index]];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      title: "Toplist",
      child: Column(
        children: [
          CupertinoContainer(
            child: Column(
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
                  secondText: (_settings.genres != null) ? "Selected: ${_getSelectedGenre()}" : null,
                  onPressed: _chooseGenre,
                ),
              ],
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




