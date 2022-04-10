import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/common.dart';

import '../data/tmdb.dart';

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
  Future<List<Person>>? _cachedFuture;

  @override
  void initState() {
    super.initState();
    // _cachedFuture = tmdb.searchMovies("Spider-Man");
  }

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
          ? PersonListItem(snapshot.data![i])
          : const Placeholder();
    };
  }
}

class PersonListItem extends StatelessWidget {
  final Person person;

  const PersonListItem(this.person, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(person),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: (person.hasProfile)
                ? CircleAvatar(
                  foregroundImage: NetworkImage(
                    TMDB.buildImageURL(person.profile!, 154),
                  ),
                )
                : CircleAvatar(
                  child: Text(person.name.substring(0, 1)),
                ),
            ),
          ),
          Expanded(child: Text(person.name)),
        ],
      ),
    );
  }
}
