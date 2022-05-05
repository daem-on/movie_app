part of "toplist.dart";

class ToplistAppearanceView extends StatefulWidget {
  const ToplistAppearanceView({Key? key}) : super(key: key);

  static Route route(ToplistSettings args) => CupertinoPageRoute(
      builder: (context) => const ToplistAppearanceView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args)
  );

  @override
  State<ToplistAppearanceView> createState() => _ToplistAppearanceViewState();
}

class _ToplistAppearanceViewState extends State<ToplistAppearanceView> {
  late ToplistSettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ModalRoute.of(context)!.settings.arguments as ToplistSettings;
    _createDynamicPreset();
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

  void _createDynamicPreset() async {
    if (_settings.preset.tag != LookPresetTag.movieBackdrop) return;
    var imagePath = _settings.list
        .firstWhere((element) => element.hasBackdrop)
        .backdrop;
    if (imagePath == null) return;

    var backgroundImage = NetworkImage(
        TMDB.buildImageURL(imagePath, 780)
    );
    var paletteGen = await PaletteGenerator.fromImageProvider(
      backgroundImage, maximumColorCount: 20,
    );
    var fg = (_settings.lightColors ? CupertinoColors.black : CupertinoColors.white);
    if (_settings.dynamicColor) fg = paletteGen.lightVibrantColor?.color ?? fg;
    var bg = (_settings.lightColors ? CupertinoColors.white : CupertinoColors.black);
    if (_settings.dynamicColor) bg = paletteGen.darkVibrantColor?.color ?? bg;

    var newPreset = LookPreset(
      topImage: backgroundImage,
      radius: const BorderRadius.all(Radius.circular(20)),
      defaultTextStyle: TextStyle(
        color: fg,
      ),
      extraPadding: const EdgeInsets.only(top: 80),
      backgroundColor: bg,
      tag: LookPresetTag.movieBackdrop
    );

    setState(() {_settings.preset = newPreset;});
  }

  void _selectLookPreset(LookPreset result) {
    setState(() {_settings.preset = result;});
    _createDynamicPreset();
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: TrailingButton(
        text: "Preview", onPressed: () {
          Navigator.of(context).push(ToplistView.route(_settings));
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
                  CupertinoTextFormFieldRow(
                    placeholder: "Title",
                    initialValue: _settings.title,
                    onChanged: (v) => _settings.title = v,
                  ),
                  AppearanceSelectorRow(
                    callback: _selectLookPreset,
                    current: _settings.preset,
                    options: const {
                      ...lookPresets,
                      "Movie backdrop": LookPreset(tag: LookPresetTag.movieBackdrop)
                    },
                  )
                ]
            ),
            CupertinoFormSection(
                header: Text("Background".toUpperCase()),
                children: [
                  CupertinoFormRow(
                    prefix: const Text("Light color scheme"),
                    child: CupertinoSwitch(value: _settings.lightColors, onChanged: (v) {
                      setState(() {_settings.lightColors = v;});
                      _createDynamicPreset();
                    }),
                  ),
                  if (_settings.useMovieBackdrop) CupertinoFormRow(
                    prefix: const Text("Dynamic colors from backdrop"),
                    child: CupertinoSwitch(value: _settings.dynamicColor, onChanged: (v) {
                      setState(() {_settings.dynamicColor = v;});
                      _createDynamicPreset();
                    }),
                  ),
                ]
            )
          ],
        ),
      )
    );
  }
}