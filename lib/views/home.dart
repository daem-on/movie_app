/// Library containing [HomeView] and [RecentlyWatchedCarousel].
library home;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database.dart';
import '../data/model.dart';
import '../data/tmdb.dart';
import 'awards/awards.dart';
import 'common.dart';
import 'filmography/filmography.dart';
import 'review/review.dart';
import 'toplist/toplist.dart';
import 'views.dart';

part 'recently_watched.dart';

/// View for the home page of the app.
///
/// Contains a carousel of recently watched movies and a button
/// for creating a new post, which opens a menu showing post formats.
///
/// - The carousel: [RecentlyWatchedCarousel]
/// - The options for the formats:
///   - [ToplistSettingsView]
///   - [AwardsSettingsView]
///   - [FilmographySettingsView]
///   - [ReviewSettingsView]
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  static Route get route => CupertinoPageRoute(
      builder: (context) => const HomeView(),
      title: "Home"
  );

  @override
  State<HomeView> createState() => _HomeViewState();
}

const double _borderWidth = 6;

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    handleNotRegistered();
  }

  /// Contents of the menu, each item is a [Route] to a settings view.
  ///
  /// These routes have to be new every time, because they can't be used
  /// after being disposed
  static Map<String, Route> get _menuContent => {
    "Toplist": ToplistSettingsView.route,
    "Awards": AwardsSettingsView.route,
    "Filmography": FilmographySettingsView.route,
    "Review": ReviewSettingsView.route
  };

  static Map<String, IconData> get _menuIcons => {
    "Toplist": CupertinoIcons.list_number,
    "Awards": CupertinoIcons.star_circle_fill,
    "Filmography": CupertinoIcons.person_2_square_stack,
    "Review": CupertinoIcons.text_alignleft
  };

  /// Handle case where username is not set yet: shows [RegisterView].
  void handleNotRegistered() async {
    if ((await SharedPreferences.getInstance()).getString("username") == null) {
      Navigator.of(context).pushAndRemoveUntil(RegisterView.route, (r) => false);
    }
  }

  Widget _buildPostMenuButton(BuildContext context, String id, bool darkMode) {
    Color textColor = darkMode ? CupertinoTheme.of(context).primaryContrastingColor : CupertinoTheme.of(context).primaryColor;
    return CupertinoButton(
      padding: const EdgeInsets.all(20),
      color: darkMode ? CupertinoTheme.of(context).primaryColor : CupertinoColors.systemBackground,
      pressedOpacity: 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_menuIcons[id]!, color: textColor),
          Text(id, style: TextStyle(color: textColor))
        ],
      ),
      onPressed: () {
        Navigator.of(context).push(_menuContent[id]!);
      },
    );
  }

  Widget _buildNewPostMenu(BuildContext context) {
    bool isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? const Color.fromARGB(255, 23, 23, 26) : CupertinoTheme.of(context).primaryColor,
      ),
      padding: const EdgeInsets.all(_borderWidth),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: _borderWidth),
            child: Text("Create new", style: TextStyle(color: CupertinoColors.white, fontSize: 20)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: _borderWidth,
              children: _menuContent.keys.map((e) => _buildPostMenuButton(context, e, isDark)).toList(),
            ),
          )
        ],
      ),
    );
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
              _buildNewPostMenu(context),
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
