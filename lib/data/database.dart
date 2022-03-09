import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

import 'model/basic.dart';

class DatabaseManager extends ChangeNotifier {
  late Database _database;

  final _recentTableCreateQuery =
      "CREATE TABLE recent(tmdbid INTEGER, day INTEGER)";

  Future<bool> _tableExists(DatabaseExecutor db, String table) async {
    var count = firstIntValue(await _database.query('sqlite_master',
        columns: ['COUNT(*)'],
        where: 'type = ? AND name = ?',
        whereArgs: ['table', table]));
    return count! > 0;
  }

  Future<void> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), 'movie_app_database.db'),
      onCreate: (db, version) {
        db.execute(_recentTableCreateQuery);
      },
      version: 4,
    );

    if (!await _tableExists(_database, "recent")) _database.execute(_recentTableCreateQuery);
  }

  Future<int> insertEntry(Movie entry) async {
    final result = await _database.insert(
      "recent",
      { "id": entry.id, "day": DateTime.now().millisecondsSinceEpoch },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
    return result;
  }

  static List<Movie> _mapsToMovies(List<Map<String, dynamic>> maps) {
    final List<Movie> returned = [];
    for (var map in maps) {
      try {
        returned.add(Movie.onlyId(map["id"]));
      } catch (e) {
        log("Error! " + e.toString());
      }
    }
    return returned;
  }

  Future<List<Movie>> listEntries() async {
    return _mapsToMovies(await _database.query('entries'));
  }

  Future<int> removeEntryById(int id) async {
    return await _database.delete("id = ?", whereArgs: [id]);
  }
}