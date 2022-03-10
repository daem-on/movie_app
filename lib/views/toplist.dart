import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/model/basic.dart';

class ToplistView extends StatefulWidget {
  const ToplistView({Key? key}) : super(key: key);

  @override
  State<ToplistView> createState() => _ToplistViewState();
}

class _ToplistViewState extends State<ToplistView> {
  final List<Movie> _list = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Toplist"),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Add movie"),
                  CupertinoButton(
                      onPressed: () async {
                        Movie? movie = await Navigator.of(context).pushNamed<dynamic>("/search");
                        if (movie == null) return;
                        setState(() {
                          _list.add(movie);
                        });
                      },
                      child: const Icon(CupertinoIcons.add_circled)
                  )
                ],
              ),
              const Divider(),
              for (var movie in _list)
                Row(children: [Text(movie.fullTitle)],)
            ],
          ),
        )
    );
  }
}
