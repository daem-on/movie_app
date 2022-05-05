part of "awards.dart";

class AwardsSettingsView extends StatefulWidget {
  const AwardsSettingsView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const AwardsSettingsView(),
      title: "Awards"
  );

  @override
  State<AwardsSettingsView> createState() => _AwardsSettingsViewState();
}

class AwardsTemplate {
  String title;
  List<String> slots;
  String displayTitle;
  AwardsTemplate(this.title, this.displayTitle, this.slots);
}

class AwardsSettings {
  String title = "";
  String username = "";
  List<Award> list = [];
  bool showUsername = true;
  bool showPosters = true;
  bool showYear = true;
  int date = DateTime.now().year;
  LookPreset preset = lookPresets["Golden border"]!;

  loadTemplate(AwardsTemplate template) {
    title = template.displayTitle;
    list = template.slots.map((element) => Award(element, "", null)).toList();
  }
}

class _AwardsSettingsViewState extends State<AwardsSettingsView> {
  final AwardsSettings _settings = AwardsSettings();
  final List<AwardsTemplate> _templates = [
    AwardsTemplate("Oscars", "The Academy Awards", oscarsTemplate),
    AwardsTemplate("Golden Globes (Movies)", "The Golden Globe Awards", goldenGlobesTemplate),
  ];
  List<Award> get _list => _settings.list;

  List<String> _optionsFrom(Map<String, dynamic> map) => ["None", ...map.keys];
  List<int> _valuesFrom(Map<String, int> map) => [0, ...map.values];

  void loadTemplate(AwardsTemplate template) {
    setState(() {
      _settings.loadTemplate(template);
    });
  }

  Future<int?> _showPickerModal(List<String> options, [int? initialItem]) {
    return showCupertinoModalPopup(
        context: context,
        semanticsDismissible: true,
        builder: (context) => PickerModal(options: options, initialItem: initialItem,)
    );
  }

  void _chooseTemplate() async {
    final List<String> names = _templates.map((e) => e.title).toList();
    final index = await _showPickerModal(names);
    if (index == null) return;

    loadTemplate(_templates[index]);
  }

  void _chooseDate() async {
    final currentYear = DateTime.now().year+1;
    final dates = List.generate(60, (index) => currentYear - index);
    final options = dates.map((e) => e.toString()).toList();
    var result = await _showPickerModal(options, dates.indexOf(_settings.date));

    if (result != null) {
      setState(() {_settings.date = dates[result];});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      trailing: (_settings.list.isEmpty) ? null :
      TrailingButton(
        onPressed: () {
          Navigator.of(context).push(AwardsAppearanceView.route(_settings));
        },
        text: "Appearance",
      ),
      child: Column(
        children: [
          CupertinoContainer(
            child: Column(
              children: [
                SettingRow(
                  text: "Choose template",
                  onPressed: _chooseTemplate,
                ),
                SettingRow(
                  text: "From year",
                  secondText: "Current: ${_settings.date}",
                  onPressed: _chooseDate,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (_settings.list.isEmpty)
                  const Align(alignment: Alignment.center, child: Text("Choose a template to start.")),
                for (final element in _settings.list)
                  CupertinoContainer(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Text(element.name),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.of(context).push(Search.route);
                            if (result != null) setState(() { element.picked = result; });
                          },
                          onLongPress: () async {
                            setState(() { element.picked = null; });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 75,
                                  color: CupertinoColors.secondarySystemBackground,
                                  child: (element.picked?.poster == null) ?
                                    const Icon(CupertinoIcons.film) :
                                    Image.network(
                                        TMDB.buildImageURL(element.picked!.poster!)
                                    ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(element.picked?.fullTitle ?? "None yet")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoTextField.borderless(
                          placeholder: "Recipient",
                          onChanged: (value) => element.comment = value,
                        )
                      ],
                    )
                  )
              ],
            )
          ),
        ],
      ),
    );
  }
}




