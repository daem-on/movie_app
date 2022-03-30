

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
  late String? backdrop;
  bool get hasPoster => poster != null;
  bool get hasBackdrop => backdrop != null;

  Movie(this.id, this.title, this.year, this.poster);

  Movie.fromJSON(this.id, Map<String, dynamic> object) {
    title = object["title"];
    if (object["release_date"] != null && object["release_date"] != "") {
      year = int.parse(object["release_date"].split("-")[0]);
    } else {
      year = null;
    }
    poster = object["poster_path"];
    backdrop = object["backdrop_path"];
  }

  String get fullTitle {
    return "$title (${year?.toString() ?? "-"})";
  }
}

class Person {
  int id;
  late String name;
  late String? profile;
  bool get hasProfile => profile != null;

  Person.fromJSON(this.id, Map<String, dynamic> object) {
    name = object["name"];
    profile = object["profile_path"];
  }

  Person(this.id, this.name);
}

class Award {
  String name;
  String comment;
  Movie? picked;
  bool get isPicked => picked != null;

  Award(this.name, this.comment, this.picked);
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