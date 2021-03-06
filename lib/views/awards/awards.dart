/// The awards format
///
/// <img alt="Example output"
/// src="https://github.com/daem-on/movie_app/raw/master/doc_assets/awards.png"
/// width=300
/// />
///
/// {@category Formats}
library awards;

import 'package:flutter/cupertino.dart';
import 'package:movie_app/preset_display.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/constants.dart';
import '../../presets/presets.dart';
import '../../data/model.dart';
import '../../data/tmdb.dart';
import '../common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../views.dart';

part 'settings.dart';
part 'appearance.dart';
part 'preview.dart';
