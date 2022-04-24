part of "review.dart";

class ReviewAppearanceView extends StatefulWidget {
  const ReviewAppearanceView({Key? key}) : super(key: key);

  static Route route(ReviewSettings args) => CupertinoPageRoute(
      builder: (context) => const ReviewAppearanceView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args)
  );

  @override
  State<ReviewAppearanceView> createState() => _ReviewAppearanceViewState();
}

class _ReviewAppearanceViewState extends State<ReviewAppearanceView> {
  late ReviewSettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ModalRoute.of(context)!.settings.arguments as ReviewSettings;
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
          Navigator.of(context).push(ReviewView.route(_settings));
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CupertinoFormSection(
                children: [
                  CupertinoFormRow(
                    prefix: const Text("Use numbers instead of stars"),
                    child: CupertinoSwitch(value: _settings.useNumbers, onChanged: (v) {
                      setState(() {_settings.useNumbers = v;});
                    }),
                  ),
                  CupertinoFormRow(
                    prefix: const Text("Align review text"),
                    child: CupertinoSlidingSegmentedControl<int>(
                      children: const {
                        0: Icon(CupertinoIcons.text_alignleft),
                        1: Icon(CupertinoIcons.text_aligncenter),
                        2: Icon(CupertinoIcons.text_alignright),
                      },
                      groupValue: _settings.alignText,
                      onValueChanged: (val) {setState(() {_settings.alignText = val??0;});},
                    ),
                  ),
                ]
            ),
            CupertinoFormSection(
                header: Text("Title".toUpperCase()),
                children: [
                  CupertinoTextFormFieldRow(
                    placeholder: "Optional",
                    initialValue: _settings.title,
                    onChanged: (v) => _settings.title = v,
                  ),
                ]
            ),
            CupertinoFormSection(
                header: Text("Review text".toUpperCase()),
                children: [
                  CupertinoTextFormFieldRow(
                    placeholder: "Optional",
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    initialValue: _settings.textReview,
                    onChanged: (v) => _settings.textReview = v,
                  ),
                ]
            ),
          ],
        ),
      )
    );
  }
}

