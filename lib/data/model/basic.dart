import 'dart:convert';
import 'dart:developer';

import '../tmdb.dart';

class Result<T> {
  T? value;
  bool get hasValue => value != null;

  Result.clear();
  Result(this.value);
}

class Movie {
  int id;
  late String title;
  late int? year;
  late String? poster;

  Movie(this.id, this.title, this.year, this.poster);

  Movie.fromJSON(this.id, Map<String, dynamic> object) {
    title = object["title"];
    if (object["release_date"] != null && object["release_date"] != "") {
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
  late String name;
  late String? profile;

  Person.fromJSON(this.id, Map<String, dynamic> object) {
    name = object["name"];
    profile = object["profile_path"];
  }

  Person(this.id, this.name);
}

Map<String, int> genres = {
  "Action": 28,
  "Adventure": 12,
  "Animation": 16,
  "Comedy": 35,
  "Crime": 80,
  "Documentary": 99,
  "Drama": 18,
  "Family": 10751,
  "Fantasy": 14,
  "History": 36,
  "Horror": 27,
  "Music": 10402,
  "Mystery": 9648,
  "Romance": 10749,
  "Science Fiction": 878,
  "TV Movie": 10770,
  "Thriller": 53,
  "War": 10752,
  "Western": 37,
};

Map<String, int> keywords = {
  "Superhero": 9715,
  "Video Game": 282,
  "World War I": 2504,
  "Spy": 470,
  "Heist": 10051,
  "Adapted": 818,
  "Coming of Age": 10683
};

Map<String, String> languages = {
  "English": "en",
  "French": "fr",
  "Italian": "it",
  "Japanese": "ja",
  "Hungarian": "hu",
  "German": "de",
  "Spanish": "es",
};

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