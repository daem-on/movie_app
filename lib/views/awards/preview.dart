part of "awards.dart";

class AwardsView extends StatefulWidget {
  const AwardsView({Key? key}) : super(key: key);

  static Route route(AwardsSettings args) => CupertinoPageRoute(
      builder: (context) => const AwardsView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args),
    fullscreenDialog: true
  );

  @override
  State<AwardsView> createState() => _AwardsViewState();
}

class _AwardsViewState extends State<AwardsView> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final args = ModalRoute.of(context)!.settings.arguments as AwardsSettings;
    return ShareablePreview(child: _Preview(settings: args));
  }
}

class _TextStyles {
  static const awardName = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w300,
  );
  static const comment = TextStyle(
  );
  static const movieTitle = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const mainTitle = TextStyle(
    fontSize: 30,
    fontFamily: "Georgia",
    fontFamilyFallback: ["serif"]
  );
  static const name = TextStyle(
    fontFamily: "Georgia",
    fontFamilyFallback: ["serif"]
  );
}

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final AwardsSettings settings;

  String _titleText() => settings.showYear
      ? "${settings.title} (${settings.date})"
      : settings.title;

  @override
  Widget build(BuildContext context) {
    return PresetDisplay(
      preset: settings.preset,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (settings.showUsername) Text(
              "${settings.username}'s picks for",
              style: _TextStyles.name,
              textAlign: TextAlign.center,
          ),
          Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(child: SvgPicture.asset(
                    "assets/Laurel_Wreath.svg",
                    height: 50,
                    color: DefaultTextStyle.of(context).style.color,
                    semanticsLabel: 'Laurels'
                )),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _titleText().toUpperCase(),
              textAlign: TextAlign.center,
              style: _TextStyles.mainTitle,
            ),
          ),
          for (final element in settings.list)
            if (element.isPicked)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    if (settings.showPosters && element.picked!.hasPoster)
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: MoviePosterSimple(element.picked!, width: 50),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(element.name, style: _TextStyles.awardName),
                          if (element.comment != "") Text(element.comment, style: _TextStyles.comment),
                          Text(element.picked!.fullTitle, style: _TextStyles.movieTitle),
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
