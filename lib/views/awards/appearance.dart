import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/awards/settings.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/toplist/preview.dart';
import 'package:movie_app/views/toplist/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _setting = true;
  late AwardsSettings _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings = ModalRoute.of(context)!.settings.arguments as AwardsSettings;
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
        text: "Preview", onPressed: () {},
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