/// Compile-time constant values
///
/// These could be stored in asset files, but these datasets are small
/// enough to just be stored in memory.
/// {@category Data}
library constants;

/// List of all genres accepted by TMDB.
const Map<String, int> genres = {
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

/// Selection of keywords from TMDB.
const Map<String, int> keywords = {
  "Superhero": 9715,
  "Video Game": 282,
  "World War I": 2504,
  "Spy": 470,
  "Heist": 10051,
  "Adapted": 818,
  "Coming of Age": 10683
};

/// Selection of languages and their ISO codes.
const Map<String, String> languages = {
  "English": "en",
  "French": "fr",
  "Italian": "it",
  "Japanese": "ja",
  "Hungarian": "hu",
  "German": "de",
  "Spanish": "es",
};

/// Template for the Academy Awards.
const oscarsTemplate = [
  "Best Picture",
  "Best Director",
  "Best Actor",
  "Best Actress",
  "Best Supporting Actor",
  "Best Supporting Actress",
  "Best Animated Feature Film",
  "Best Animated Short Film",
  "Best Cinematography",
  "Best Costume Design",
  "Best Documentary Feature",
  "Best Documentary Short Subject",
  "Best Film Editing",
  "Best International Feature Film",
  "Best Live Action Short Film",
  "Best Makeup and Hairstyling",
  "Best Original Score",
  "Best Original Song",
  "Best Production Design",
  "Best Sound",
  "Best Visual Effects",
  "Best Adapted Screenplay",
  "Best Original Screenplay"
];

/// Template for the Golden Globes.
const goldenGlobesTemplate = [
  "Best Motion Picture – Drama",
  "Best Motion Picture – Musical or Comedy",
  "Best Motion Picture – Foreign Language",
  "Best Motion Picture – Animated",
  "Best Director",
  "Best Actor – Drama",
  "Best Actor – Musical or Comedy",
  "Best Actress – Drama",
  "Best Actress – Musical or Comedy",
  "Best Supporting Actor",
  "Best Supporting Actress",
  "Best Screenplay",
  "Best Original Score",
  "Best Original Song"
];
