import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/awards/settings.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/filmography/settings.dart';
import 'package:movie_app/views/register.dart';
import 'package:movie_app/views/toplist/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const HomeView(),
      title: "Home"
  );

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    handleNotRegistered();
  }

  void handleNotRegistered() async {
    if ((await SharedPreferences.getInstance()).getString("username") == null) {
      Navigator.of(context).pushAndRemoveUntil(RegisterView.route, (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CupertinoButton.filled(
                child: const Text("Go to Toplist"),
                onPressed: () {
                  Navigator.of(context).push(ToplistSettingsView.route);
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CupertinoButton.filled(
                child: const Text("Go to Awards"),
                onPressed: () {
                  Navigator.of(context).push(AwardsSettingsView.route);
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CupertinoButton.filled(
                child: const Text("Go to Filmography"),
                onPressed: () {
                  Navigator.of(context).push(FilmographySettingsView.route);
                }
              ),
            ),
            CupertinoButton(
              child: const Text("Delete username"),
              onPressed: () async {
                (await SharedPreferences.getInstance()).remove("username");
              }
            ),
          ],
        ),
      ),
    );
  }
}
