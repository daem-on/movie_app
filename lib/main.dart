/// This is the starting point for the app.
///
/// The UI is made to look like a native iOS app, and for this
/// it uses a lot of components from the `flutter/cupertino` package.
///
/// Here we create a [CupertinoApp], which handles all navigation with a
/// [Navigator]. We will push other pages onto this navigator later, the first
/// page to be shown is [HomeView]. More details on this: [MovieApp].
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
      title: "Supercritical",
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
        primaryColor: const Color(0xFFC70D8E),
        primaryContrastingColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
        brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness
      ),
      home: const HomeView(),
    );
  }
}

