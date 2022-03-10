import 'package:flutter/cupertino.dart';
import 'package:marquee/marquee.dart';

class MovieTitleMarquee extends StatelessWidget {
  final String title;

  const MovieTitleMarquee({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 50,
        child: Marquee(
            pauseAfterRound: const Duration(seconds: 1),
            blankSpace: 10,
            fadingEdgeStartFraction: 0,
            startPadding: 10,
            fadingEdgeEndFraction: 0.3,
            text: title
        )
    );
  }
}