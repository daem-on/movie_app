part of 'presets.dart';

/// This is a map of [LookPreset]s, which can be used with a [PresetDisplay]
/// to change the appearance of a post. This map can be expanded with new
/// presets - generated automatically or created by the user - during runtime.
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

  "Black and white film": LookPreset(
    defaultTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontFamilyFallback: ["Georgia", "serif"]
    ),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF000000),
          Color(0xFF1C1C1C),
          Color(0xFF000000),
        ]
    ),
    radius: BorderRadius.all(Radius.circular(20)),
    accentColor: Color(0xFFE6E6E6)
  ),

  "Blue plastic": LookPreset(
    defaultTextStyle: TextStyle(
      color: Color.fromARGB(255, 0, 46, 95),
    ),
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 167, 215, 255),
          Color.fromARGB(255, 209, 234, 255),
          Color.fromARGB(255, 25, 130, 216),
        ]
    ),
    radius: BorderRadius.all(Radius.circular(20)),
    accentColor: Color.fromARGB(255, 0, 112, 231),
    borderGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 25, 130, 216),
          Color.fromARGB(255, 209, 234, 255),
          Color.fromARGB(255, 167, 215, 255),
        ]
    ),
  )
};