part of "filmography.dart";

class FilmographyAppearanceView extends StatefulWidget {
  const FilmographyAppearanceView({Key? key}) : super(key: key);

  static Route route(FilmographySettings args) => CupertinoPageRoute(
      builder: (context) => const FilmographyAppearanceView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args)
  );

  @override
  State<FilmographyAppearanceView> createState() => _FilmographyAppearanceViewState();
}

class _FilmographyAppearanceViewState extends State<FilmographyAppearanceView> {
  late FilmographySettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ModalRoute.of(context)!.settings.arguments as FilmographySettings;
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    var name = (await SharedPreferences.getInstance()).getString("username");
    setState(() {_settings.username = name ?? "";});
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: TrailingButton(
        text: "Preview", onPressed: () {
          Navigator.of(context).push(FilmographyView.route(_settings));
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CupertinoFormSection(
                children: [
                  CupertinoFormRow(
                    prefix: const Text("Show username"),
                    child: CupertinoSwitch(value: _settings.showUsername, onChanged: (v) {
                      setState(() {_settings.showUsername = v;});
                    }),
                  ),
                  CupertinoFormRow(
                    prefix: const Text("Show posters"),
                    child: CupertinoSwitch(value: _settings.showPosters, onChanged: (v) {
                      setState(() {_settings.showPosters = v;});
                    }),
                  ),
                  CupertinoFormRow(
                    prefix: const Text("Use numbers instead of stars"),
                    child: CupertinoSwitch(value: _settings.useNumbers, onChanged: (v) {
                      setState(() {_settings.useNumbers = v;});
                    }),
                  ),
                  AppearanceSelectorRow(
                    callback: (result) => setState(() {_settings.preset = result;}),
                    current: _settings.preset,
                  )
                ]
            ),
            CupertinoFormSection(
              header: Text("Title".toUpperCase()),
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: "Title",
                  initialValue: _settings.title,
                  onChanged: (v) => _settings.title = v,
                )
              ]
            ),
            CupertinoRadioGroup<SortMovies>(
              options: const {
                "By popularity": SortMovies.popularity,
                "By year": SortMovies.year,
                "By my rating": SortMovies.rating,
              },
              title: "Sort movies",
              currentValue: _settings.sort,
              callback: (v) => setState(() => _settings.sort = v)
            )
          ],
        ),
      )
    );
  }
}

class CupertinoRadioGroup<T> extends StatelessWidget {
  const CupertinoRadioGroup({Key? key, required this.options, required this.title, required this.currentValue, required this.callback}) : super(key: key);

  final Map<String, T> options;
  final T currentValue;
  final String title;
  final Function(T val) callback;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      header: Text(title.toUpperCase()),
      children: [
        for (final option in options.entries)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: CupertinoFormRow(
              prefix: Text(option.key),
              child: SizedBox(
                height: 30,
                child: AnimatedOpacity(
                  opacity: (currentValue==option.value) ? 1 : 0,
                  duration: const Duration(milliseconds: 100),
                  child: const Icon(CupertinoIcons.check_mark)
                )
              ),
            ),
            onTap: () {callback(option.value);},
          )
      ]
    );
  }
}
