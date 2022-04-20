import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/TextStyles.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/filmography/settings.dart';
import 'package:movie_app/views/review/settings.dart';

import '../../data/tmdb.dart';
import '../common.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

  static Route route(ReviewSettings args) => CupertinoPageRoute(
      builder: (context) => const ReviewView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args),
    fullscreenDialog: true
  );

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

final imageKey = GlobalKey();

class _ReviewViewState extends State<ReviewView> {
  late ReviewSettings _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as ReviewSettings;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ShareablePreview(
      child: _Preview(settings: _args,)
    );
  }
}

const _aspectIcons = {
  "Editing": CupertinoIcons.scissors,
  "Set design": CupertinoIcons.building_2_fill,
  "Cinematography": CupertinoIcons.crop,
  "Lighting": CupertinoIcons.lightbulb,
  "Visual effects": CupertinoIcons.wand_stars,
  "Special effects": CupertinoIcons.burst,
};

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final ReviewSettings settings;

  get _textAlign =>
      [TextAlign.start, TextAlign.center, TextAlign.end]
      [settings.alignText];

  Widget _displayRating(RatedItem mr, [double size = 30]) {
    if (settings.useNumbers) {
      return Text("${mr.rating}/10", style: TextStyles.bigRating);
    } else {
      return RatingBar.builder(
        initialRating: mr.rating / 2,
        ignoreGestures: true,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: size,
        itemBuilder: (context, _) => const Icon(
          CupertinoIcons.star_fill,
          color: Color(0xffff155f),
        ),
        onRatingUpdate: (_) {},
      );
    }
  }

  _displayAspect(Aspect element) {
    return Row(
      children: [
        if (_aspectIcons.containsKey(element.item))
          Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(child: Icon(_aspectIcons[element.item]))),
        Text(element.item + " ", style: TextStyles.movieTitle),
        _displayRating(element, 15)
      ],
    );
  }

  _displayPerson(RatedItem<PersonCredit> element) {
    return Row(
      children: [
        ProfilePicture(person: element.item),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(element.item.name, style: TextStyles.movieTitle),
                const Text(" • "),
                Text(element.item.job ?? element.item.character ?? ""),
              ],
            ),
            _displayRating(element, 15)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0d52c7),
              Color(0xff751ece),
              Color(0xff5e033e),
            ]
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: CupertinoColors.white),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: MoviePosterSimple(settings.movie!, width: 50,),
                  ),
                  Text(
                    "${settings.username}'s review of",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    settings.movie!.title, textAlign: TextAlign.center,
                    style: TextStyles.movieTitle,
                  ),
                  if (settings.title != "")
                    Text(
                      settings.title, textAlign: TextAlign.center,
                      style: TextStyles.mainTitleSans
                    ),
                  if (settings.textReview != "")
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        settings.textReview, style: TextStyles.comment,
                        textAlign: _textAlign,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              for (final element in settings.aspects)
                _displayAspect(element),
              for (final element in settings.people)
                _displayPerson(element),
            ],
          ),
        ),
      ),
    );
  }
}
