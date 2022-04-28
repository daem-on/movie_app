import 'package:flutter/cupertino.dart';

import '../preset_display.dart';

abstract class LookPresets {
  static const goldenBorder = LookPreset(
    "Golden border",
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
    "Purple gradient",
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

  static const popcorn = LookPreset(
    "Popcorn background",
    topImage: AssetImage('assets/popcorn.jpg'),
    defaultTextStyle: TextStyle(color: CupertinoColors.white),
    radius: BorderRadius.all(Radius.circular(20)),
    extraPadding: EdgeInsets.only(top: 40)
  );

  static const seatsBottomBackground = LookPreset(
    "Cinema seats",
    bottomImage: AssetImage('assets/seats.jpg'),
    defaultTextStyle: TextStyle(color: CupertinoColors.white),
    backgroundColor: Color(0xFF340404),
    radius: BorderRadius.all(Radius.circular(20)),
    extraPadding: EdgeInsets.only(bottom: 70)
  );
}

const presetsAsOptions = {
  "Popcorn": LookPresets.popcorn,
  "Seats": LookPresets.seatsBottomBackground,
  "Gold border": LookPresets.goldenBorder,
  "Purple gradient": LookPresets.purpleGradient,
};