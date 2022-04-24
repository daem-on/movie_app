
/// A wrapper class to be used in modals to differentiate between
/// an empty value being returned or no value being returned.
class Result<T> {
  T? value;
  bool get hasValue => value != null;

  Result.clear();
  Result(this.value);
}

/// Represents a movie.
class Movie {
  /// TMDB id.
  int id;
  /// Title of the movie, without year.
  late String title;
  /// Release date year.
  late int? year;
  /// URL of the poster. Use with `TMDB.buildImageURL`.
  late String? poster;
  /// URL of a background image. Use with `TMDB.buildImageURL`.
  late String? backdrop;
  late double? popularity;
  late double? voteAvg;
  bool get hasPoster => poster != null;
  bool get hasBackdrop => backdrop != null;

  Movie(this.id, this.title, this.year, this.poster);

  /// Creates a movie from a TMDB response JSON.
  Movie.fromJSON(this.id, Map<String, dynamic> object) {
    title = object["title"];
    if (object["release_date"] != null && object["release_date"] != "") {
      year = int.parse(object["release_date"].split("-")[0]);
    } else {
      year = null;
    }
    poster = object["poster_path"];
    backdrop = object["backdrop_path"];
    popularity = object["popularity"];
    dynamic va = object["vote_average"];
    if (va.runtimeType == int) {
      voteAvg = va.toDouble();
    } else {
      voteAvg = va;
    }
  }

  /// Title of the movie, with year.
  String get fullTitle {
    return "$title (${year?.toString() ?? "-"})";
  }
}

/// An entry in a [Person]'s [Filmography].
///
/// Only contains a movie and the job or character performed.
class MovieCredit extends Movie {
  String? job;
  String? character;

  MovieCredit.fromJSON(int id, Map<String, dynamic> object) : super.fromJSON(id, object) {
    job = object["job"];
    character = object["character"];
  }
}

/// The list of movies somebody has worked on.
///
/// Separated into [cast] and [crew], where [MovieCredit.character] and
/// [MovieCredit.job] can be filled out, respectively.
class Filmography {
  List<MovieCredit> cast;
  List<MovieCredit> crew;
  Filmography(this.cast, this.crew);
}

/// Represents a person.
class Person {
  int id;
  late String name;
  /// URL of the profile picture. Use with `TMDB.buildImageURL`.
  late String? profile;
  bool get hasProfile => profile != null;

  /// Creates a person from a TMDB response JSON.
  Person.fromJSON(this.id, Map<String, dynamic> object) {
    name = object["name"];
    profile = object["profile_path"];
  }

  Person(this.id, this.name);
}

/// An entry in a [Movie]'s [PersonCredits].
///
/// Only contains the person and the job or character performed.
class PersonCredit extends Person {
  String? job;
  String? character;

  PersonCredit.fromJSON(int id, Map<String, dynamic> object) : super.fromJSON(id, object) {
    job = object["job"];
    character = object["character"];
  }
}

/// The list of people who worked on a movie.
///
/// Separated into [cast] and [crew], where [PersonCredit.character] and
/// [PersonCredit.job] can be filled out, respectively.
class PersonCredits {
  List<PersonCredit> cast;
  List<PersonCredit> crew;
  PersonCredits(this.cast, this.crew);
}

/// Represents an award of an awards show, with possibly a recipient movie.
class Award {
  String name;
  String comment;
  /// The recipient, if a movie has been picked.
  Movie? picked;
  bool get isPicked => picked != null;

  Award(this.name, this.comment, this.picked);
}

/// The abstract representation of anything
/// that can be rated on an integer scale.
abstract class Rated {
  int rating;

  Rated(this.rating);
}

/// A generic class that contains an [item] of type [T] and
/// also provides a [rating] for it.
class RatedItem<T> extends Rated {
  T item;

  RatedItem(this.item, [int? rating]) : super(rating??0);
}

/// A rated aspect of a movie.
typedef Aspect = RatedItem<String>;

/// A rated person.
typedef PersonRating = RatedItem<Person>;

/// A rated movie.
typedef MovieRating = RatedItem<Movie>;