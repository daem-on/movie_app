/// The toplist format.
///
/// <img alt="Example output"
/// src="https://github.com/daem-on/movie_app/raw/master/doc_assets/toplist.png"
/// width=300
/// />
///
/// {@category Formats}
library toplist;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../data/constants.dart';
import '../../data/model.dart';
import '../../data/tmdb.dart';
import '../../preset_display.dart';
import '../common.dart';
import '../views.dart';
import '../../presets/presets.dart';

part 'appearance.dart';
part 'settings.dart';
part 'preview.dart';

final Map<String, String> _langLookup = languages.map((key, value) => MapEntry(value, key));
final Map<int, String> _genreLookup = genres.map((key, value) => MapEntry(value, key));
final Map<int, String> _keywordLookup = keywords.map((key, value) => MapEntry(value, key));