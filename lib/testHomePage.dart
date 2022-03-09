import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    int? response = await showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select amount'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('By 1'),
            onPressed: () {
              Navigator.pop(context, 1);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('By 10'),
            onPressed: () {
              Navigator.pop(context, 10);
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );

    if (response == null) return;
    setState(() {
      _counter += response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.title),
        ),
        child: Stack(
          children: [
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       const Text(
            //         'You have pushed the button this many times:',
            //       ),
            //       Text(
            //         '$_counter',
            //         style: Theme.of(context).textTheme.headline1,
            //       ),
            //     ],
            //   ),
            // ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  MovieInfoTest(movieId: 634649),
                  MovieInfoTest(movieId: 414906),
                ],
              ),
            ),
            FloatingButton(
              onPressed: _incrementCounter,
            )
          ],
        )
    );
  }
}

class FloatingButton extends StatelessWidget {
  final void Function()? onPressed;

  const FloatingButton({
    Key? key, this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: 32,
      child: Center(
        child: CupertinoButton.filled(
          borderRadius: BorderRadius.circular(1000),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          onPressed: onPressed,
          child: IntrinsicWidth(
            child: Row(
              children: const [
                Icon(CupertinoIcons.add),
                Text("Increment"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}