import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/TextStyles.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/filmography/settings.dart';

import '../../data/tmdb.dart';
import '../common.dart';

class FilmographyView extends StatefulWidget {
  const FilmographyView({Key? key}) : super(key: key);

  static Route route(FilmographySettings args) => CupertinoPageRoute(
      builder: (context) => const FilmographyView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args),
    fullscreenDialog: true
  );

  @override
  State<FilmographyView> createState() => _FilmographyViewState();
}

final imageKey = GlobalKey();

class _FilmographyViewState extends State<FilmographyView> {
  late FilmographySettings _args;
  List<MovieRating> _filteredList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as FilmographySettings;
    _filteredList = _args.list.where((e) => e.rating != 0).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ShareablePreview(
      child: _Preview(settings: _args, filteredList: _filteredList,)
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
    required this.filteredList,
  }) : super(key: key);

  final FilmographySettings settings;
  final List<MovieRating> filteredList;

  Widget _displayRating(MovieRating mr) {
    if (settings.useNumbers) {
      return Text("${mr.rating}/10", style: TextStyles.bigRating);
    } else {
      return RatingBar.builder(
        initialRating: mr.rating / 2,
        ignoreGestures: true,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 30,
        itemBuilder: (context, _) => const Icon(
          CupertinoIcons.star_fill,
          color: Color(0xffff155f),
        ),
        onRatingUpdate: (_) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (settings.person != null)
                    ProfilePicture(person: settings.person!, radius: 30,),
                  Text(settings.title, style: TextStyles.mainTitleSans),
                ],
              ),
            ),
            for (final element in filteredList)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: MoviePosterSimple(element.movie, width: 60,)
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(element.movie.fullTitle, style: TextStyles.movieTitle),
                          _displayRating(element)
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
