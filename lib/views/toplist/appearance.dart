import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/toplist/preview.dart';
import 'package:movie_app/views/toplist/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _setting = true;
  late ToplistSettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ModalRoute.of(context)!.settings.arguments as ToplistSettings;
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
          Navigator.of(context).push(ToplistView.route(_settings));
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
                    child: CupertinoSwitch(value: _setting, onChanged: (v) {
                      setState(() {_setting = v;});
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