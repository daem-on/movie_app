import 'package:flutter/cupertino.dart';
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

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final ReviewSettings settings;

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
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
