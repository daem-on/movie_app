import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/TextStyles.dart';
import 'package:movie_app/views/filmography/appearance.dart';
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

enum Role {both, cast, crew, director}
enum SortMovies {popularity, year, rating}

class FilmographySettings {
  String title = "";
  String username = "";
  Person? person;
  Role role = Role.both;
  List<MovieRating> list = [];
  bool showUsername = true;
  bool showPosters = true;
  bool useNumbers = false;
  SortMovies sort = SortMovies.popularity;
}

class OptionsModal extends StatelessWidget {
  const OptionsModal({
    Key? key,
    required this.options,
  }) : super(key: key);

  final Map<String, dynamic> options;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text(
        "Show roles",
        style: TextStyle(fontSize: 24)
      ),
      actions: [
        for (final element in options.entries)
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(element.value);
            },
            child: Text(element.key)
          )
      ],
    );
  }
}

class _FilmographySettingsViewState extends State<FilmographySettingsView> {
  final FilmographySettings _settings = FilmographySettings();
  List<MovieRating> get _list => _settings.list;
  final _tmdb = TMDB();
  static final roleOptions = {
    "All": Role.both,
    "Cast": Role.cast,
    "Crew": Role.crew,
    "Director": Role.director,
  };

  int _popularitySorter(Movie a, Movie b) {
    return ((b.popularity??0)-(a.popularity??0)).toInt();
  }

  void getList() async {
    final person = _settings.person;
    if (person == null) return;
    final filmography = await _tmdb.filmography(person.id);
    List<MovieCredit> list;
    switch (_settings.role) {
      case Role.crew:
        list = filmography.crew;
        break;
      case Role.director:
        list = filmography.crew;
        list.retainWhere((e) => e.job?.toLowerCase()=="director");
        break;
      case Role.cast:
        list = filmography.cast;
        break;
      case Role.both:
        list = [...filmography.cast, ...filmography.crew];
    }
    list.sort(_popularitySorter);
    setState(() {
      _settings.list = list.map((e) => MovieRating(e, 0)).toList();
      _settings.title = "Filmography of ${person.name}";
    });
  }

  void _choosePerson() async {
    Person? person = await Navigator.of(context).push(PeopleSearch.route);
    if (person == null) return;
    _settings.role = await showCupertinoModalPopup(
        context: context,
        semanticsDismissible: false,
        builder: (context) => OptionsModal(options: roleOptions)
    ) ?? Role.both;
    setState(() {
      _settings.person = person;
    });
    getList();
  }

  String? _creditDescription(MovieCredit credit) {
    if (credit.character!=null) return "as ${credit.character}";
    return credit.job;
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: (_settings.list.isEmpty) ? null :
      TrailingButton(
        onPressed: () {
          Navigator.of(context).push(FilmographyAppearanceView.route(_settings));
        },
        text: "Appearance",
      ),
      child: Column(
        children: [
          CupertinoContainer(
            child: Column(
              children: [
                SettingRow(
                  text: "Choose person",
                  secondText: _settings.person!=null ? "Current: ${_settings.person?.name}" : null,
                  onPressed: _choosePerson,
                  icon: const Icon(CupertinoIcons.person),
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
                            Text(element.item.fullTitle),
                            Text(
                              _creditDescription(element.item as MovieCredit) ?? "",
                              style: TextStyles.subtitle,
                            ),
                            NonNullStarRatingSlider(
                              rating: element.rating,
                              callback: (rating) {
                                setState(() { element.rating = rating; });
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





