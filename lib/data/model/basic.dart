import 'dart:convert';
import 'dart:developer';

import '../tmdb.dart';

class Movie {
  int id;
  late String title;
  late int? year;
  late String? poster;

  Movie(this.id, this.title, this.year, this.poster);

  Movie._onlyId(this.id);

  Movie.fromJSON(this.id, Map<String, dynamic> object) {
    _loadFromJSON(object);
  }

  void _loadFromJSON(Map<String, dynamic> object) {
    title = object["title"];
    if (object["release_date"] != "") {
      year = int.parse(object["release_date"].split("-")[0]);
    } else {
      year = null;
    }
    poster = object["poster_path"];
  }

  String get fullTitle {
    return "$title (${year?.toString() ?? "-"})";
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