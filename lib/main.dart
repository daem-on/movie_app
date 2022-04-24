import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/views/home.dart';


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

