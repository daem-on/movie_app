library toplist;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../data/constants.dart';
import '../../data/look_presets.dart';
import '../../data/model/basic.dart';
import '../../data/tmdb.dart';
import '../../preset_display.dart';
import '../common.dart';
import '../search.dart';
import '../../text_styles.dart';
import '../discover.dart';

part 'appearance.dart';
part 'settings.dart';
part 'preview.dart';

final Map<String, String> _langLookup = languages.map((key, value) => MapEntry(value, key));
final Map<int, String> _genreLookup = genres.map((key, value) => MapEntry(value, key));
final Map<int, String> _keywordLookup = keywords.map((key, value) => MapEntry(value, key));