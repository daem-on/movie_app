part of 'views.dart';

/// A person search view.
///
/// The user is able to provide a search query, pick a person from
/// a list of results, and the resulting [Person] will be returned in `pop()`
///
/// ![Search people](https://github.com/daem-on/movie_app/raw/master/doc_assets/search_person.png)
class PeopleSearch extends StatefulWidget {
  const PeopleSearch({Key? key}) : super(key: key);

  static Route<Person> get route => CupertinoPageRoute(
      builder: (context) => const PeopleSearch(),
      title: "Search"
  );

  @override
  State<PeopleSearch> createState() => _PeopleSearchState();
}

class _PeopleSearchState extends State<PeopleSearch> {
  var tmdb = TMDB();
  /// The result of the search. Null if the search hasn't happened yet.
  Future<List<Person>>? _cachedFuture;

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CupertinoSearchTextField(
              autofocus: true,
              onSubmitted: (value) => setState(() {
                _cachedFuture = tmdb.search<Person>(value);
              }),
            ),
          ),
          Expanded(
            child: CupertinoContainer(
              child: (_cachedFuture != null) ? FutureBuilder(
                future: _cachedFuture,
                builder: (context, AsyncSnapshot<List<Person>> snapshot) => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                  itemBuilder: _buildChildren(snapshot),
                ),
              ) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget Function(BuildContext, int) _buildChildren(
      AsyncSnapshot<List<Person>> snapshot) {
    return (context, i) {
      return snapshot.hasData
          ? _PersonListItem(snapshot.data![i])
          : const Placeholder();
    };
  }
}

/// A widget which displays the profile picture and
/// name of the given [person]. Calls [Navigator.pop] when tapped.
class _PersonListItem extends StatelessWidget {
  final Person person;

  const _PersonListItem(this.person, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(person),
      child: Row(
        children: [
          ProfilePicture(person: person),
          Expanded(child: Text(person.name)),
        ],
      ),
    );
  }
}
