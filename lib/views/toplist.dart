import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/model/basic.dart';
import 'common.dart';

class ToplistView extends StatefulWidget {
  const ToplistView({Key? key}) : super(key: key);

  @override
  State<ToplistView> createState() => _ToplistViewState();
}

class ToplistSettings {
  String? genre;

  ToplistSettings({this.genre});
}

class ToplistTemplate {
  ToplistSettings settings;
  String title;
  ToplistTemplate(this.title, this.settings);
}

class _ToplistViewState extends State<ToplistView> {
  final List<Movie> _list = List.empty(growable: true);
  ToplistSettings _settings = ToplistSettings();
  final List<ToplistTemplate> _templates = [
    ToplistTemplate("90's comedies", ToplistSettings(genre: "comedy")),
    ToplistTemplate("Superhero movies", ToplistSettings(genre: "superhero")),
    ToplistTemplate("Horror movies", ToplistSettings(genre: "horror")),
    ToplistTemplate("Japanese movies", ToplistSettings(genre: "japanese")),
  ];

  void _gotoSearchAddMovie() async {
    Movie? movie = await Navigator.of(context).pushNamed<dynamic>("/search");
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Toplist"),
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 80),
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
                      onPressed: _gotoSearchAddMovie,
                      icon: const Icon(CupertinoIcons.compass),
                    ),
                    SettingRow(
                      text: "Restrict to genre",
                      secondText: (_settings.genre != null) ? "Selected: ${_settings.genre}" : null,
                      onPressed: () {},
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
        )
    );
  }
}


