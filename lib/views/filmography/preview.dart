part of "filmography.dart";

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

  int _popularitySorter(MovieRating a, MovieRating b) => ((b.item.popularity??0)-(a.item.popularity??0)).toInt();
  int _yearSorter(MovieRating a, MovieRating b) => (a.item.year??0)-(b.item.year??0);
  int _ratingSorter(MovieRating a, MovieRating b) => a.rating-b.rating;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as FilmographySettings;
    _filteredList = _args.list.where((e) => e.rating != 0).toList(growable: false);
    switch (_args.sort) {
      case SortMovies.popularity:
        _filteredList.sort(_popularitySorter);
        break;
      case SortMovies.year:
        _filteredList.sort(_yearSorter);
        break;
      case SortMovies.rating:
        _filteredList.sort(_ratingSorter);
        break;
    }
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
        // unratedColor: const Color(0x5C747474),
        itemBuilder: (context, _) => Icon(
          CupertinoIcons.star_fill,
          color: settings.preset.accentColor,
        ),
        onRatingUpdate: (_) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return PresetDisplay(
      preset: settings.preset,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (settings.person != null)
                  ProfilePicture(person: settings.person!, radius: 30,),
                Text(settings.title, style: TextStyles.mainTitleSans, textAlign: TextAlign.center,),
              ],
            ),
          ),
          for (final element in filteredList)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                textDirection: i++%2==0 ? TextDirection.rtl:TextDirection.ltr,
                children: [
                  if (settings.showPosters) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: MoviePosterSimple(element.item, width: 60,),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: i%2==0 ? CrossAxisAlignment.start:CrossAxisAlignment.end,
                        children: [
                          Text(
                            element.item.fullTitle, style: TextStyles.movieTitle,
                            textAlign: i%2==0 ? TextAlign.start:TextAlign.end,
                          ),
                          _displayRating(element)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
