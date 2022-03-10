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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const Divider(thickness: 3),
              Expanded(
                child: ReorderableListView(
                  children: [
                    for (var movie in _list)
                      Dismissible(
                        confirmDismiss: (direction) async => false,
                        background: Container(color: CupertinoColors.destructiveRed,),
                        key: Key(movie.id.toString()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Row(children: [Text(movie.fullTitle)],)
                        ),
                      )
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Movie item = _list.removeAt(oldIndex);
                      _list.insert(newIndex, item);
                    });
                  }
                ),
              )
            ],
          ),
        )
    );
  }
}
