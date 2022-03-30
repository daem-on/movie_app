import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/data/tmdb.dart';
import 'package:movie_app/views/discover.dart';
import 'package:movie_app/views/toplist/settings.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';

import '../common.dart';

class ToplistView extends StatefulWidget {
  const ToplistView({Key? key}) : super(key: key);

  static Route route(ToplistSettings args) => CupertinoPageRoute(
      builder: (context) => const ToplistView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args),
    fullscreenDialog: true
  );

  @override
  State<ToplistView> createState() => _ToplistViewState();
}

class _ToplistViewState extends State<ToplistView> {
  late Widget _background;
  late ToplistSettings _args;
  late List<Color> _gradient;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as ToplistSettings;
    if (_args.useMovieBackdrop && _args.list.any((element) => element.hasBackdrop)) {
      var path = _args.list
          .firstWhere((element) => element.hasBackdrop)
          .backdrop!;
      _background = Image.network(
          TMDB.buildImageURL(path, 780)
      );
      _gradient = _linearGradient;
    } else {
      _background = Image.asset('assets/popcorn.jpg');
      _gradient = _brightTopGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ShareablePreview(
      child: _Preview(
        settings: _args,
        gradient: _gradient,
        background: _background,
        extraPadding: const EdgeInsets.only(top: 60)
      )
    );
  }
}

const _borderRadius = BorderRadius.all(Radius.circular(20));
const _brightTopGradient = [
  Color(0xFF000000),
  Color(0x3C000000),
  Color(0x00000000)
];
const _linearGradient =  [Color(0xFF000000), Color(0x00000000)];

class _TextStyles {
  static const number = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w300,
  );
  static const movieTitle = TextStyle(
  );
  static const mainTitle = TextStyle(
      fontSize: 30,
  );
}

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
    required this.gradient,
    required this.background,
    this.extraPadding = EdgeInsets.zero,
  }) : super(key: key);

  final EdgeInsetsGeometry extraPadding;
  final ToplistSettings settings;
  final List<Color> gradient;
  final Widget background;
  DiscoverArguments get da => settings.arguments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        color: settings.lightColors ? CupertinoColors.white : CupertinoColors.black,
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: settings.lightColors ? CupertinoColors.black : CupertinoColors.white),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: _borderRadius,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradient,
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: background,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30)
                  .add(extraPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      settings.title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 40
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (settings.showUsername) Text("By: ${settings.username}"),
                      if (da.laterThan != null) Text("From ${da.laterThan}"),
                      if (da.earlierThan != null) Text("To ${da.earlierThan}"),
                    ],
                  ),
                  for (var i = 0; i < settings.list.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          if (settings.showPosters && settings.list[i].hasPoster)
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: MoviePosterSimple(settings.list[i], width: 50),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#${i+1}", style: _TextStyles.number),
                                Text(settings.list[i].fullTitle, style: _TextStyles.movieTitle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
