import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/views/discover.dart';
import 'package:movie_app/views/search.dart';
import 'package:movie_app/views/toplist/appearance.dart';

import '../../data/model/basic.dart';
import '../../data/tmdb.dart';
import '../common.dart';

class AwardsSettingsView extends StatefulWidget {
  const AwardsSettingsView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const AwardsSettingsView(),
      title: "Awards"
  );

  @override
  State<AwardsSettingsView> createState() => _AwardsSettingsViewState();
}

class AwardsTemplate {
  String title;
  List<String> slots;
  AwardsTemplate(this.title, this.slots);
}

class ToplistSettings {
  String title = "";
  String username = "";
  List<Award> list = [];
  int date = DateTime.now().year;

  loadTemplate(AwardsTemplate template) {
    title = template.title;
    list = template.slots.map((element) => Award(element, null)).toList();
  }
}

class _AwardsSettingsViewState extends State<AwardsSettingsView> {
  final ToplistSettings _settings = ToplistSettings();
  final List<AwardsTemplate> _templates = [
    AwardsTemplate("Oscars", ["Set design", "Best Picture"]),
  ];
  List<Award> get _list => _settings.list;

  List<String> _optionsFrom(Map<String, dynamic> map) => ["None", ...map.keys];
  List<int> _valuesFrom(Map<String, int> map) => [0, ...map.values];

  void loadTemplate(AwardsTemplate template) {
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

  void _chooseDate() async {
    final currentYear = DateTime.now().year;
    final dates = List.generate(60, (index) => currentYear - index);
    final options = dates.map((e) => e.toString()).toList();
    var result = await _showPickerModal(options, dates.indexOf(_settings.date));

    if (result != null) {
      setState(() {_settings.date = result;});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: TrailingButton(
        onPressed: () {},
        text: "Appearance",
      ),
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
                  text: "From year",
                  secondText: "Current: ${_settings.date}",
                  onPressed: _chooseDate,
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoContainer(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                children: [
                  for (final element in _settings.list)
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: SizedBox(
                                width: 50,
                                child: (element.picked?.poster == null) ?
                                  const Icon(CupertinoIcons.film) :
                                  Image.network(
                                      TMDB.buildImageURL(element.picked!.poster!)
                                  ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(element.name),
                                  Text(element.picked?.fullTitle ?? "None yet")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        final result = await Navigator.of(context).push(Search.route);
                        if (result != null) setState(() { element.picked = result; });
                      },
                      onLongPress: () async {
                        setState(() { element.picked = null; });
                      },
                    )
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}




