import 'package:flutter/cupertino.dart';

import '../preset_display.dart';

const Map<String, LookPreset> lookPresets = {
  "Golden border": LookPreset(
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
  ),

  "Purple gradient": LookPreset(
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
  ),

  "Popcorn background": LookPreset(
    topImage: AssetImage('assets/popcorn.jpg'),
    defaultTextStyle: TextStyle(color: CupertinoColors.white),
    radius: BorderRadius.all(Radius.circular(20)),
    extraPadding: EdgeInsets.only(top: 40)
  ),

  "Cinema seats": LookPreset(
    bottomImage: AssetImage('assets/seats.jpg'),
    defaultTextStyle: TextStyle(color: CupertinoColors.white),
    backgroundColor: Color(0xFF1C0000),
    radius: BorderRadius.all(Radius.circular(20)),
    extraPadding: EdgeInsets.only(bottom: 70),
    accentColor: Color(0xFF7D1E22)
  ),

  "Fancy": LookPreset(
    defaultTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontFamilyFallback: ["Georgia", "serif"]
    ),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF340000),
          Color(0xFF580C10),
          Color(0xFF240505),
        ]
    ),
    radius: BorderRadius.all(Radius.circular(20)),
    accentColor: Color(0xFFF8AD1A)
  ),
};