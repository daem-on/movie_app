import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/model/basic.dart';

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
          color: CupertinoColors.systemBackground.resolveFrom(context),
        ),
        child: child
    );
  }
}

class PickerModal extends StatelessWidget {
  PickerModal({
    Key? key,
    required this.options,
    this.button = "Select",
    int? initialItem,
  }) : super(key: key) {
    _controller = FixedExtentScrollController(initialItem: initialItem ?? 0);
  }

  final List<String> options;
  late final FixedExtentScrollController _controller;
  final String button;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        color: CupertinoColors.systemBackground.resolveFrom(context),
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
                child: CupertinoButton.filled(child: Text(button), onPressed: () {
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

class DateModal extends StatelessWidget {
  DateModal({
    Key? key,
  }) : super(key: key);

  DateTime _value = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: DateTime(DateTime.now().year),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime value) {_value = value;},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: CupertinoButton(
                    child: const Text("Clear"),
                    onPressed: () {Navigator.of(context).pop(Result.clear());}
                  ),),
                  Expanded(child: CupertinoButton.filled(
                    child: const Text("Done"),
                    onPressed: () {Navigator.of(context).pop(Result(_value));}
                  ),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DurationModal extends StatelessWidget {
  DurationModal({
    Key? key,
    required this.value
  }) : super(key: key);

  Duration value;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Expanded(
              child: CupertinoTimerPicker(
                initialTimerDuration: value,
                mode: CupertinoTimerPickerMode.hm,
                onTimerDurationChanged: (Duration v) {value = v;},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: CupertinoButton(
                    child: const Text("Clear"),
                    onPressed: () {Navigator.of(context).pop(Result.clear());}
                  ),),
                  Expanded(child: CupertinoButton.filled(
                    child: const Text("Done"),
                    onPressed: () {Navigator.of(context).pop(Result(value));}
                  ),),
                ],
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
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text),
              if (secondText != null)
                Text(secondText!, style: CupertinoTheme.of(context).textTheme.actionTextStyle,)
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
        navigationBar: const CupertinoNavigationBar(),
        child: SafeArea(child: child)
    );
  }
}