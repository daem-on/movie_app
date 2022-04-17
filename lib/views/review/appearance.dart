import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/filmography/preview.dart';
import 'package:movie_app/views/filmography/settings.dart';
import 'package:movie_app/views/review/preview.dart';
import 'package:movie_app/views/review/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          children: [],
        ),
      )
    );
  }
}

