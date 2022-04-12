import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/data/tmdb.dart';
import 'package:movie_app/views/discover.dart';
import 'package:movie_app/views/toplist/settings.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';

import '../../TextStyles.dart';
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

final imageKey = GlobalKey();

class _ToplistViewState extends State<ToplistView> {
  late ImageProvider _background;
  late ToplistSettings _args;
  late List<Color> _gradient;
  PaletteGenerator? _paletteGenerator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as ToplistSettings;
    if (_args.useMovieBackdrop && _args.list.any((element) => element.hasBackdrop)) {
      var path = _args.list
          .firstWhere((element) => element.hasBackdrop)
          .backdrop!;
      _background = NetworkImage(
          TMDB.buildImageURL(path, 780)
      );
      _gradient = _linearGradient;
    } else {
      _background = const AssetImage('assets/popcorn.jpg');
      _gradient = _brightTopGradient;
    }
    _updatePaletteGenerator();
  }

  void _updatePaletteGenerator() async {
    if (!_args.dynamicColor) {
      _paletteGenerator = null;
      return;
    }
    _paletteGenerator = await PaletteGenerator.fromImageProvider(
      _background,
      maximumColorCount: 20,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ShareablePreview(
      child: _Preview(
        settings: _args,
        gradient: _gradient,
        background: _background,
        palette: _paletteGenerator,
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

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
    required this.gradient,
    required this.background,
    required this.palette,
    this.extraPadding = EdgeInsets.zero,
  }) : super(key: key);

  final EdgeInsetsGeometry extraPadding;
  final ToplistSettings settings;
  final List<Color> gradient;
  final ImageProvider background;
  final PaletteGenerator? palette;
  DiscoverArguments get da => settings.arguments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        color: palette?.darkVibrantColor?.color ??
            (settings.lightColors ? CupertinoColors.white : CupertinoColors.black),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
            color: palette?.lightVibrantColor?.color ??
            (settings.lightColors ? CupertinoColors.black : CupertinoColors.white)
        ),
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
                child: Image(
                  key: imageKey,
                  image: background,
                )
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
                      style: TextStyle(
                        fontSize: 40,
                        color: palette?.colors.elementAt(2)
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
                                Text("#${i+1}", style: TextStyles.number),
                                Text(settings.list[i].fullTitle, style: TextStyles.movieTitle),
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
