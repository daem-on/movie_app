part of "review.dart";

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
        itemBuilder: (context, _) => Icon(
          CupertinoIcons.star_fill,
          color: LookPresets.purpleGradient.accentColor,
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
    return PresetDisplay(
      preset: LookPresets.purpleGradient,
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(child: _displayRating(RatedItem<dynamic>(null, settings.overallRating))),
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
    );
  }
}
