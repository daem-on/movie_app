# movie_app

Share your reviews of movies with your friends

This app was made as part of a Software Engineering Laboratory university course. The following
is the required developer documentation.

## App description
The app can be used to create image posts in various formats. These posts can then be shared
with others on social media. The posts can be movie reviews, movie toplists, etc.

<img src="https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg" width="50">

All of the movie and person data comes from TheMovieDB.

## Architecture
The software architecture is completely standard Flutter app architecture. No state management
or other libraries are used, and data is accessed with `sqflite` for the database and `http`
for TheMovieDB API. These choices are obvious for an app of this small scale.

### App structure
To create a post, the user goes through these pages: *Settings*, *Appearance*, *Preview*.

*Settings* contains all the items related to the movies and people which will appear in the
post. *Appearance* contains all the items to do with the appearance, and some of the content
of the post, but they don't affect the movies or people.

### Building
This app is created with Flutter. To build, use the Flutter cli or the plugin in Android Studio
or VSCode.

To generate API docs (the html files), run `flutter pub global run dartdoc .`

## More details
When viewing this page in the API docs view, click this link to continue:

[Continue to `main` library](main/main-library.html)