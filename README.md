# Supercritical

Share your reviews of movies with your friends

This app was made as part of a Software Engineering Laboratory university course. The following
is the required developer documentation.

## App description
The app can be used to create image posts in various formats. These posts can then be shared
with others on social media. The posts can be movie reviews, movie toplists, etc.

<img src="https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg" width="100">

All of the movie and person data comes from TheMovieDB.

## Architecture
The software architecture is completely standard Flutter app architecture. No state management
or other libraries are used, and data is accessed with `sqflite` for the database and `http`
for TheMovieDB API.

The small scale of this app, and the single developer, are the reasons behind these choices.

No dependency injection solutions or [InheritedWidget]s were used, because the hierarchical
structure provided by Flutter was adequate for managing state and access to libraries.
The [DatabaseManager] class is only used in one place, which makes it very simple to implement,
since there's no need to synchronise with other places it would be displayed.
Whenever [TMDB] is used, it is a separate instance created locally, which can be done because it's
stateless. (It should probably be refactored to only have static methods.)

Flutter also provides a great way to handle references to images, [ImageProvider]. Whenever some
function takes an image it will display as a parameter, it doesn't take a URL but an ImageProvider,
since you can pass asset images or network images depending on what you need.

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
> **About the links on this page**
> The links will only be clickable when viewed in the Flutter API docs view. (See *Building*)

### Overview
The libraries for the main content of the app, which correspond to
the formats of posts which can be created in the app:
- [Awards](awards/awards-library.html)
- [Filmography](filmography/filmography-library.html)
- [Review](review/review-library.html)
- [Toplist](toplist/toplist-library.html)

[Common](common/common-library.html) contains the components shared by all UI parts. This could
be refactored into separate files, but currently only exists in one file.

[Views](views/views-library.html) contains views outside of the
four main libraries, like search, discover, etc.

### Data
- [Model](model/model-library.html) is where classes like [Movie]
(which is the data model for movies in the app) are declared.
- [Constants](constants/constants-library.html) contains compile-time
constants.
- [TMDB](tmdb/tmdb-library.html) is where requests to the API are
handled.
- [Database](database/database-library.html) is the data access layer
for the data stored in SQLite.
  Each format the user can create has a series of views the user will go through to create
  it. These views are *Settings*, *Appearance* and *Preview*.

### Structure

#### Settings
This is the place where the post settings related to movies and people can be set. This is
the content of the post, as opposed to the appearance of the post.

This page is usually made up of [CupertinoContainer]s, with [SettingRow]s in them. This is the first
step in creating a post, and so the Settings object is always created here, but will continue
to exist through the other two views, and won't change even if the user navigates back to this page.

#### Appearance
This is where the settings that don't concern movies or people are. This is usually made up of
[CupertinoFormSection]s and [CupertinoFormRow]s, but the settings object is still the same one
we get from the *Settings* view route arguments.

#### Preview
This is where the final post is shown on the screen, along with a share button.

### List
These are the views for each of the formats:

[AwardsSettingsView] > [AwardsAppearanceView] > [AwardsView]  
[FilmographySettingsView] > [FilmographyAppearanceView] > [FilmographyView]  
[ReviewSettingsView] > [ReviewAppearanceView] > [ReviewView]  
[ToplistSettingsView] > [ToplistAppearanceView] > [ToplistView]  

[Continue to `main` library](main/main-library.html)