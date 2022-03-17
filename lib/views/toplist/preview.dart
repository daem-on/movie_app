import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/testHomePage.dart';
import 'package:movie_app/views/discover.dart';
import 'package:movie_app/views/toplist/settings.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';

class ToplistView extends StatefulWidget {
  const ToplistView({Key? key}) : super(key: key);

  static Route route(ToplistSettings args) => CupertinoPageRoute(
      builder: (context) => const ToplistView(),
      title: "Appearance",
      settings: RouteSettings(arguments: args),
    fullscreenDialog: true
  );

  @override
  State<ToplistView> createState() => _ToplistViewState();
}

GlobalKey previewContainerKey = GlobalKey();

class _ToplistViewState extends State<ToplistView> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final args = ModalRoute.of(context)!.settings.arguments as ToplistSettings;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: RepaintBoundary(
                  key: previewContainerKey,
                  child: _Preview(settings: args),
              ),
            ),
          ),
          FloatingButton(
              onPressed: () {
                ShareFilesAndScreenshotWidgets().shareScreenshot(
                    previewContainerKey,
                    800,
                    "Title",
                    "Name.png",
                    "image/png",
                    text: "This is the caption!"
                );
              },
              text: "Share",
              icon: const Icon(CupertinoIcons.share)
          )
        ]
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final ToplistSettings settings;
  DiscoverArguments get da => settings.arguments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CupertinoColors.systemYellow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              settings.title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 40
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("By: ${settings.username}"),
              if (da.laterThan != null) Text("From ${da.laterThan}"),
              if (da.earlierThan != null) Text("To ${da.earlierThan}"),
            ],
          ),
          for (var i = 0; i < settings.list.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${i+1}"),
                Text(settings.list[i].fullTitle),
              ],
            ),
        ],
      ),
    );
  }
}
