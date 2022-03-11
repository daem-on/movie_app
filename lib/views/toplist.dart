import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/model/basic.dart';

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
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Toplist"),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Column(
            children: [
              SettingRow(
                text: "Start with a template",
                onPressed: _chooseTemplate,
              ),
              SettingRow(
                text: "Add movie",
                onPressed: _gotoSearchAddMovie,
                icon: const Icon(CupertinoIcons.add_circled),
              ),
              SettingRow(
                text: "Restrict to genre",
                secondText: "Selected: ${_settings.genre}",
                onPressed: () {},
              ),
              const Divider(thickness: 3),
              Expanded(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Row(children: [Text(movie.fullTitle)],)
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
              )
            ],
          ),
        )
    );
  }
}

class PickerModal extends StatelessWidget {
  PickerModal({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<String> options;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                scrollController: _controller,
                itemExtent: 50,
                // this is actually unnecessary as we're doing a StatelessWidget
                onSelectedItemChanged: (_) {},
                children: options.map((e) => Center(child: Text(e))).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton.filled(child: const Text("Select"), onPressed: () {
                Navigator.of(context).pop(_controller.selectedItem);
              }),
            )
          ],
        ),
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final Icon icon;
  final void Function()? onPressed;
  final String text;
  final String? secondText;

  const SettingRow({
    Key? key,
    this.icon = const Icon(CupertinoIcons.arrow_right),
    required this.onPressed,
    required this.text,
    this.secondText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text),
              if (secondText != null)
                Text(secondText!, style: Theme.of(context).textTheme.bodyMedium,)
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: icon
          )
        ],
      ),
    );
  }
}
