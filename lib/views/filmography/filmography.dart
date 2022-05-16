/// The filmography format.
///
/// <img alt="Example output"
/// src="https://github.com/daem-on/movie_app/raw/master/doc_assets/filmography.png"
/// width=300
/// />
///
/// {@category Formats}
library filmography;

import 'package:flutter/cupertino.dart';
import '../../preset_display.dart';
import '../common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presets/presets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../data/model.dart';
import '../../data/tmdb.dart';
import '../views.dart';

import 'package:flutter/services.dart';

part 'settings.dart';
part 'appearance.dart';
part 'preview.dart';
