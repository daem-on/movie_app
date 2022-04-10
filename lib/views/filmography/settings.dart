import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/search_people.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../data/model/basic.dart';
import '../../data/tmdb.dart';
import '../common.dart';

class FilmographySettingsView extends StatefulWidget {
  const FilmographySettingsView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const FilmographySettingsView(),
      title: "Filmography"
  );

  @override
  State<FilmographySettingsView> createState() => _FilmographySettingsViewState();
}

class FilmographySettings {
  String title = "";
  String username = "";
  Person? person;
  List<Movie> list = [];
  List<int> ratings = [];
  bool showUsername = true;
  bool showPosters = true;
}

class _FilmographySettingsViewState extends State<FilmographySettingsView> {
  final FilmographySettings _settings = FilmographySettings();
  List<Movie> get _list => _settings.list;
  final _tmdb = TMDB();

  void getList() async {
    if (_settings.person == null) return;
    final filmography = await _tmdb.filmography(_settings.person!.id);
    setState(() {
      _settings.list = [...filmography.cast, ...filmography.crew];
    });
  }

  void _choosePerson() async {
    Person? person = await Navigator.of(context).push(PeopleSearch.route);
    if (person == null) return;
    setState(() {
      _settings.person = person;
    });
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: (_settings.list.isEmpty) ? null :
      TrailingButton(
        onPressed: () {},
        text: "Appearance",
      ),
      child: Column(
        children: [
          CupertinoContainer(
            child: Column(
              children: [
                SettingRow(
                  text: "Choose person",
                  secondText: "Current: ${_settings.person?.name}",
                  onPressed: _choosePerson,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
                children: [
                  if (_settings.list.isEmpty)
                    const Align(alignment: Alignment.center, child: Text("Choose a person to start.")),
                  for (final element in _settings.list)
                    CupertinoContainer(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Text(element.fullTitle),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 0.5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                CupertinoIcons.star_fill,
                                color: CupertinoColors.systemYellow,
                              ),
                              onRatingUpdate: (rating) {
                                log(rating.toString());
                              },
                            ),
                          ],
                        )
                    )
                ],
              )
          ),
        ],
      ),
    );
  }
}




