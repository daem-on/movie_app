part of "awards.dart";

class AwardsAppearanceView extends StatefulWidget {
  const AwardsAppearanceView({Key? key}) : super(key: key);

  static Route route(AwardsSettings args) => CupertinoPageRoute(
      builder: (context) => const AwardsAppearanceView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args)
  );

  @override
  State<AwardsAppearanceView> createState() => _AwardsAppearanceViewState();
}

class _AwardsAppearanceViewState extends State<AwardsAppearanceView> {
  late AwardsSettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ModalRoute.of(context)!.settings.arguments as AwardsSettings;
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  void _getUsername() async {
    var name = (await SharedPreferences.getInstance()).getString("username");
    setState(() {_settings.username = name ?? "";});
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: TrailingButton(
        text: "Preview", onPressed: () {
          Navigator.of(context).push(AwardsView.route(_settings));
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CupertinoFormSection(
                // header: Text("Settings".toUpperCase(), style: TextStyle(fontSize: 20)),
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
                    prefix: const Text("Show year"),
                    child: CupertinoSwitch(value: _settings.showYear, onChanged: (v) {
                      setState(() {_settings.showYear = v;});
                    }),
                  ),
                  CupertinoTextFormFieldRow(
                    placeholder: "Title",
                    initialValue: _settings.title,
                    onChanged: (v) => _settings.title = v,
                  )
                ]
            )
          ],
        ),
      )
    );
  }
}