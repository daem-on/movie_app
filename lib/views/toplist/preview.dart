part of "toplist.dart";

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
    _args = ModalRoute
        .of(context)!
        .settings
        .arguments as ToplistSettings;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ShareablePreview(
      child: _Preview(
        settings: _args,
      )
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final ToplistSettings settings;
  DiscoverArguments get da => settings.arguments;
  String get later => da.laterThan!.split("-")[0];
  String get earlier => da.earlierThan!.split("-")[0];

  @override
  Widget build(BuildContext context) {
    _IconWithText.gradient = LinearGradient(
        colors: [settings.preset.accentColor
            ?? settings.preset.defaultTextStyle!.color!],
      stops: const [0]
    );
    return PresetDisplay(
      preset: settings.preset,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).add(const EdgeInsets.only(bottom: 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  settings.title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 40),
                ),
                if (settings.showUsername) Text("A list by ${settings.username}"),
              ],
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 20,
            children: [
              if (da.laterThan != null && da.earlierThan != null)
                _IconWithText(
                    icon: CupertinoIcons.calendar,
                    text: (later != earlier) ? "$later-$earlier" : earlier
              ) else if (da.laterThan != null) _IconWithText(
                  icon: CupertinoIcons.calendar,
                  text: "$later-"
              ) else if (da.earlierThan != null) _IconWithText(
                  icon: CupertinoIcons.arrow_counterclockwise,
                  text: "Before $earlier"
              ),
              if (da.genre != null) _IconWithText(
                  icon: CupertinoIcons.film_fill, text: "${_genreLookup[da.genre]}"
              ),
              if (da.keyword != null) _IconWithText(
                  icon: CupertinoIcons.tag_fill, text: "${_keywordLookup[da.keyword]}"
              ),
              if (da.shorterThan != null) _IconWithText(
                  icon: CupertinoIcons.clock_fill, text: "Under ${da.shorterThan}m"
              ),
              if (da.longerThan != null) _IconWithText(
                  icon: CupertinoIcons.clock_fill, text: "Over ${da.longerThan}m"
              ),
              if (da.originalLang != null) _IconWithText(
                  icon: CupertinoIcons.captions_bubble_fill, text: "In ${_langLookup [da.originalLang]}"
              ),
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
    );
  }
}

class _IconWithText extends StatelessWidget {
  const _IconWithText({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;
  static LinearGradient gradient =
    const LinearGradient(colors: [CupertinoColors.white], stops: [0]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ShaderMask(
              blendMode: BlendMode.srcOut,
              shaderCallback: gradient.createShader,
              child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, size: 60)
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.only(top: 8), child: Text(text))
        ],
      ),
    );
  }
}
