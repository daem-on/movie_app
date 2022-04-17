import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/common.dart';

import '../data/tmdb.dart';

class SelectCredit extends StatefulWidget {
  const SelectCredit({Key? key}) : super(key: key);

  static Route<PersonCredit> route(PersonCredits credits) => CupertinoPageRoute(
      builder: (context) => const SelectCredit(),
      title: "Search",
      settings: RouteSettings(arguments: credits)
  );

  @override
  State<SelectCredit> createState() => _SelectCreditState();
}

class _SelectCreditState extends State<SelectCredit> {
  var tmdb = TMDB();
  Future<List<Movie>>? _cachedFuture;
  late PersonCredits _args;
  late List<PersonCredit> _allCredits;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as PersonCredits;
    _allCredits = _args.cast + _args.crew;
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      child: ListView.builder(
        itemCount: _allCredits.length,
          itemBuilder: _itemBuilder
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var element = _allCredits.elementAt(index);
    return GestureDetector(
      child: Column(
        children: [
          Text(element.name),
          Text(element.job ?? element.character ?? "None"),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop(element);
      },
    );
  }
}