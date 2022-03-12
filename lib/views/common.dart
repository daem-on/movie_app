import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const CupertinoContainer({
    Key? key, required this.child, this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: CupertinoColors.systemBackground,
        ),
        child: child
    );
  }
}

class PickerModal extends StatelessWidget {
  PickerModal({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<String> options;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        color: CupertinoColors.white,
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                scrollController: _controller,
                itemExtent: 50,
                // this is actually unnecessary as we're doing a StatelessWidget
                onSelectedItemChanged: (_) {},
                children: options.map((e) => Center(child: Text(e))).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: CupertinoButton.filled(child: const Text("Select"), onPressed: () {
                  Navigator.of(context).pop(_controller.selectedItem);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final Icon icon;
  final void Function()? onPressed;
  final String text;
  final String? secondText;

  const SettingRow({
    Key? key,
    this.icon = const Icon(CupertinoIcons.arrow_right),
    required this.onPressed,
    required this.text,
    this.secondText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text),
              if (secondText != null)
                Text(secondText!, style: Theme.of(context).textTheme.bodyMedium,)
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
              child: icon
          )
        ],
      ),
    );
  }
}

class MovieAppScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const MovieAppScaffold({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
        ),
        child: Container(
            padding: const EdgeInsets.only(top: 80),
            child: child
        )
    );
  }
}