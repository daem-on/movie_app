import 'package:flutter/cupertino.dart';

import '../preset_display.dart';

abstract class LookPresets {
  static const goldenBorder = LookPreset(
    borderGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xffffd25f),
          Color(0xffffbd2c),
        ]
    ),
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff151515),
          Color(0xff0e0e0e),
        ]
    ),
    radius: BorderRadius.all(Radius.circular(20)),
    defaultTextStyle: TextStyle(color: CupertinoColors.white),
    accentColor: Color(0xffffbd2c)
  );

  static const purpleGradient = LookPreset(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff0d52c7),
          Color(0xff751ece),
          Color(0xff5e033e),
        ]
    ),
    defaultTextStyle: TextStyle(color: CupertinoColors.white),
    radius: BorderRadius.all(Radius.circular(20)),
    accentColor: Color(0xffff155f)
  );
}