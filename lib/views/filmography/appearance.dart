import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/filmography/preview.dart';
import 'package:movie_app/views/filmography/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    prefix: const Text("Use numbers instead of stars"),
                    child: CupertinoSwitch(value: _settings.useNumbers, onChanged: (v) {
                      setState(() {_settings.useNumbers = v;});
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