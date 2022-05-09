/// These are fullscreen views which can be used by the settings pages, for
/// search, discover, etc.
library views;

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/model.dart';
import 'package:movie_app/views/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/tmdb.dart';
import '../presets/presets.dart';
import 'home.dart';

part 'search.dart';
part 'search_people.dart';
part 'select_credit.dart';
part 'register.dart';
part 'discover.dart';