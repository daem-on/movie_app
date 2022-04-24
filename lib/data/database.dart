import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:movie_app/data/tmdb.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

import 'model/basic.dart';

/// Local database manager.
///
/// You must call [initDatabase] before using the database.
class DatabaseManager extends ChangeNotifier {
  late Database _database;
  final TMDB tmdb = TMDB();

  final _recentTableCreateQuery =
      "CREATE TABLE recent(tmdbid INTEGER, day INTEGER)";

  Future<bool> _tableExists(DatabaseExecutor db, String table) async {
    var count = firstIntValue(await _database.query('sqlite_master',
        columns: ['COUNT(*)'],
        where: 'type = ? AND name = ?',
        whereArgs: ['table', table]));
    return count! > 0;
  }

  /// Initializes the database. Must be called before using it.
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

  /// Insert a movie into recently watched list.
  Future<int> insertEntry(Movie entry) async {
    final result = await _database.insert(
      "recent",
      { "tmdbid": entry.id, "day": DateTime.now().millisecondsSinceEpoch },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
    return result;
  }

  List<Future<Movie>> _mapsToMovies(List<Map<String, dynamic>> maps) {
    final List<Future<Movie>> returned = [];
    for (var map in maps) {
      try {
        returned.add(tmdb.movieFromId(map["tmdbid"]));
      } catch (e) {
        log("Error! " + e.toString());
      }
    }
    return returned;
  }

  /// Returns the recently watched movies with most recent first.
  /// Only returns futures of movies, because only IDs are stored, and
  /// the movies have to be fetched from [TMDB].
  Future<List<Future<Movie>>> listEntries() async {
    return _mapsToMovies(await _database.query("recent", orderBy: "day DESC"));
  }

  /// Remove all recently watched movies with given id.
  Future<int> removeEntryById(int id) async {
    return await _database.delete("recent", where: "tmdbid = ?", whereArgs: [id]);
  }
}