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
      title: "Filmography"
  );

  @override
  State<ReviewSettingsView> createState() => _ReviewSettingsViewState();
}

class ReviewSettings {
  String title = "";
  String username = "";
  Movie? movie;
  int overallRating = 0;
  List<PersonCredit> list = [];
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
    if (result != null) setState(() { _settings.list.add(result); });
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
          if (_movieChosen) Column(
            children: [
              CupertinoContainer(
                child: Column(
                  children: [
                    const Text("Your overall rating"),
                    StarRatingSlider(
                      rating: _settings.overallRating,
                      callback: (rating) {
                        setState(() {_settings.overallRating = rating;});
                      }
                    )
                  ],
                )
              ),
              CupertinoContainer(
                child: SettingRow(
                  text: "Add rating for person",
                  onPressed: _addCredit,
                )
              ),
              CupertinoContainer(
                child: Column(
                  children: [
                    for (final credit in _settings.list)
                      Text(credit.name)
                  ],
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}




