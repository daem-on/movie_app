import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:movie_app/TextStyles.dart';
import 'package:movie_app/views/filmography/appearance.dart';
import 'package:movie_app/views/review/appearance.dart';
import 'package:movie_app/views/search_people.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../data/model/basic.dart';
import '../../data/tmdb.dart';
import '../common.dart';
import '../search.dart';
import '../select_credit.dart';

class ReviewSettingsView extends StatefulWidget {
  const ReviewSettingsView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const ReviewSettingsView(),
      title: "Review"
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

class _ReviewSettingsViewState extends State<ReviewSettingsView> {
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
    _credits = await _tmdb.movieCredits(result.id);
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
    return Column(
      children: [
        Text(text),
        NonNullStarRatingSlider(
            rating: element.rating,
            callback: (rating) {
              setState(() {element.rating = rating;});
            }
        )
      ],
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
                      ),
                      SettingRow(
                        text: "Add rating for aspect",
                        onPressed: _addAspect,
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




