import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/testHomePage.dart';
import 'package:movie_app/views/discover.dart';
import 'package:movie_app/views/home.dart';
import 'package:movie_app/views/search.dart';
import 'package:movie_app/views/toplist/settings.dart';

import 'data/database.dart';
import 'data/model/basic.dart';
import 'data/tmdb.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemPink,
        primaryContrastingColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
        brightness: WidgetsBinding.instance?.platformDispatcher.platformBrightness
      ),
      home: const HomeView(),
    );
  }
}

