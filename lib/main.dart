/// This is the starting point for the app.
///
/// The UI is made to look like a native iOS app, and for this
/// it uses a lot of components from the `flutter/cupertino` package.
///
/// Here we create a [CupertinoApp], which handles all navigation with a
/// [Navigator]. We will push other pages onto this navigator later, the first
/// page to be shown is [HomeView]. More details on this: [MovieApp].
///
/// ## Overview
/// The libraries for the main content of the app, which correspond to
/// the formats of posts which can be created in the app:
/// - [Awards](../awards/awards-library.html)
/// - [Filmography](../filmography/filmography-library.html)
/// - [Review](../review/review-library.html)
/// - [Toplist](../toplist/toplist-library.html)
///
/// [Common](../common/common-library.html) contains the components
/// shared by all UI parts.
///
/// [Views](../views/views-library.html) contains views outside of the
/// four main libraries, like search, discover, etc.
///
/// ### Data
/// - [Model](../model/model-library.html) is where classes like [Movie]
/// (which is the data model for movies in the app) are declared.
/// - [Constants](../constants/constants-library.html) contains compile-time
/// constants.
/// - [TMDB](../tmdb/tmdb-library.html) is where requests to the API are
/// handled.
/// - [Database](../database/database-library.html) is the data access layer
/// for the data stored in SQLite.
///
/// {@category Main}
library main;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/views/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MovieApp());
}

/// The main app class.
///
/// Contains some settings which affect the entire app, like the main theme
/// color, and some workaround code to support using material components
/// inside the app, which is a [CupertinoApp], and wouldn't normally support
/// other components.
class MovieApp extends StatelessWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'movie_app',
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        primaryColor: const Color(0xFFC70D8E),
        // primaryColor: CupertinoColors.systemBlue,
        primaryContrastingColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
        brightness: WidgetsBinding.instance?.platformDispatcher.platformBrightness
      ),
      home: const HomeView(),
    );
  }
}

