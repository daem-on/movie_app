import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/awards/settings.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/filmography/settings.dart';
import 'package:movie_app/views/recently_watched.dart';
import 'package:movie_app/views/register.dart';
import 'package:movie_app/views/review/settings.dart';
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

  // These routes have to be new every time, because they can't be used
  // after being disposed
  static Map<String, Route> get _menuContent => {
    "Toplist": ToplistSettingsView.route,
    "Awards": AwardsSettingsView.route,
    "Filmography": FilmographySettingsView.route,
    "Review": ReviewSettingsView.route
  };

  void handleNotRegistered() async {
    if ((await SharedPreferences.getInstance()).getString("username") == null) {
      Navigator.of(context).pushAndRemoveUntil(RegisterView.route, (r) => false);
    }
  }

  void _openMenu() async {
    final choice = await showCupertinoModalPopup<Route>(
        context: context,
        semanticsDismissible: true,
        builder: (context) => OptionsModal(options: _menuContent, title: "Create new")
    );
    if (choice == null) return;
    Navigator.of(context).push(choice);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: RecentlyWatchedCarousel(),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CupertinoButton.filled(
                  padding: EdgeInsets.zero,
                  borderRadius: const BorderRadius.all(Radius.circular(90)),
                  child: const Icon(CupertinoIcons.add),
                  onPressed: _openMenu
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
      ),
    );
  }
}
