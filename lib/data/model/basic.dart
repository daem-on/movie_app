import 'dart:convert';
import 'dart:developer';

import '../tmdb.dart';

class Movie {
  int id;
  late String title;
  late int year;
  late String? poster;

  Movie(this.id, this.title, this.year);

  Movie.onlyId(this.id);

  Future<void> _populate(TMDB db) async {
    var response = await db.fetchDetailsById(id);
    if (response.statusCode != 200) return;
    var result = jsonDecode((await db.fetchDetailsById(id)).body);
    title = result["title"];
    year = int.parse(result["release_date"].split("-")[0]);
    poster = result["poster_path"];
  }

  static Future<Movie> fromId(int id, TMDB db) async {
    var r = Movie.onlyId(id);
    await r._populate(db);
    return r;
  }

  String get fullTitle {
    return "$title (${year.toString()})";
  }
}

class Person {
  int id;
  String name;

  Person(this.id, this.name);
}

class Award {
  String name;
  Movie? picked;

  Award(this.name, this.picked);
}

abstract class Rated {
  int rating;

  Rated(this.rating);
}

class Aspect extends Rated {
  String name;

  Aspect(this.name, int rating) : super(rating);
}

class PersonRating extends Rated {
  Person person;

  PersonRating(this.person, int rating) : super(rating);
}

class MovieRating extends Rated {
  Movie movie;

  MovieRating(this.movie, int rating) : super(rating);
}