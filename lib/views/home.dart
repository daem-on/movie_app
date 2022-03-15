import 'package:flutter/cupertino.dart';
import 'package:movie_app/views/common.dart';
import 'package:movie_app/views/toplist/settings.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return MovieAppScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton.filled(
              child: const Text("Go to Toplist"),
              onPressed: () {
                Navigator.of(context).push(ToplistSettingsView.route);
              }
            )
          ],
        ),
      ),
    );
  }
}
