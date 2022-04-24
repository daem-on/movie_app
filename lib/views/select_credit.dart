import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/model/basic.dart';
import 'package:movie_app/views/common.dart';

import '../TextStyles.dart';
import '../data/tmdb.dart';

/// Shows a list of [PersonCredits], where the user can select a
/// [PersonCredit] which will be returned in [Navigator.pop].
///
/// Divides credits into cast and crew, which are shown separately.
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
  late PersonCredits _args;
  /// The selected view. Cast is false, Crew is true.
  bool _selectedView = false;
  /// The currently displayed credits (cast or crew).
  List<PersonCredit> get _currentCredits => _selectedView ? _args.crew : _args.cast;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as PersonCredits;
  }

  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoSlidingSegmentedControl<bool>(
              children: const {
                false: SizedBox(width: 100, child: Center(child: Text("Cast"))),
                true: Text("Crew"),
              },
              groupValue: _selectedView,
              onValueChanged: (bool? t) {
                setState(() {
                  _selectedView = t??false;
                });
              }),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _currentCredits.length,
                itemBuilder: _itemBuilder
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var element = _currentCredits.elementAt(index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            ProfilePicture(person: element),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(element.name),
                Text(element.job ?? element.character ?? "None", style: TextStyles.subtitle,),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pop(element);
        },
      ),
    );
  }
}