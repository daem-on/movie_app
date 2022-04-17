import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_files_and_screenshot_widgets_plus/share_files_and_screenshot_widgets_plus.dart';

import '../data/model/basic.dart';
import '../data/tmdb.dart';

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

// ignore: must_be_immutable
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

// Actually I agree that this should not be immutable but it works fine
// and doesn't use setState() at all. Also it's not my fault the timepicker
// doesn't have a controller
// ignore: must_be_immutable
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
  final Widget? trailing;

  const MovieAppScaffold({
    Key? key,
    required this.child,
    this.trailing
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: trailing,
        ),
        child: SafeArea(child: child)
    );
  }
}

class TrailingButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const TrailingButton({
    Key? key, required this.text, required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
            child: Text.rich(
              TextSpan(
                text: String.fromCharCode(CupertinoIcons.forward.codePoint),
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: CupertinoIcons.forward.fontFamily,
                  package: CupertinoIcons.forward.fontPackage,
                ),
              ),
            ),
          )
        ],
      ),
      padding: EdgeInsets.zero,
    );
  }
}

class FloatingButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Icon icon;

  const FloatingButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.icon = const Icon(CupertinoIcons.add)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: 32,
      child: Center(
        child: CupertinoButton.filled(
          borderRadius: BorderRadius.circular(1000),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: onPressed,
          child: IntrinsicWidth(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: icon,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShareablePreview extends StatelessWidget {
  ShareablePreview({
    Key? key,
    required this.child,
  }) : super(key: key);

  final GlobalKey previewContainerKey = GlobalKey();
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.black,
      ),
      child: Stack(fit: StackFit.expand, children: [
        SafeArea(
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: previewContainerKey,
              child: child,
            ),
          ),
        ),
        FloatingButton(
            onPressed: () {
              ShareFilesAndScreenshotWidgets().shareScreenshot(
                  previewContainerKey, 800, "Title", "Name.png", "image/png",
                  text: "This is the caption!");
            },
            text: "Share",
            icon: const Icon(CupertinoIcons.share))
      ]),
    );
  }
}

class MoviePosterSimple extends StatelessWidget {
  final Movie movie;
  final double width;
  final int posterWidth;

  const MoviePosterSimple(this.movie, {
    this.width = 154,
    this.posterWidth = 92,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (movie.poster != null)
    ? Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width / 10),
        child: Image.network(
          TMDB.buildImageURL(movie.poster!, posterWidth),
          width: width,
        ),
      ),
    )
    : Center(
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          color: CupertinoColors.tertiarySystemGroupedBackground,
          child: const Center(child: Icon(CupertinoIcons.film)),
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key, required this.person, this.radius}) : super(key: key);
  final Person person;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: (person.hasProfile)
          ? CircleAvatar(foregroundImage: NetworkImage(TMDB.buildImageURL(person.profile!, 154)), radius: radius)
          : CircleAvatar(child: Text(person.name.substring(0, 1)), radius: radius,),
      ),
    );
  }
}


class StarRatingSlider extends StatelessWidget {
  const StarRatingSlider({
    Key? key,
    required this.rating, required this.callback,
  }) : super(key: key);

  final int rating;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: rating/2,
          minRating: 0.5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(
            CupertinoIcons.star_fill,
            color: CupertinoColors.systemYellow,
          ),
          onRatingUpdate: (r) {callback((r*2).toInt());},
        ),
        CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {callback(0);},
            child: const Icon(CupertinoIcons.arrow_counterclockwise)
        )
      ],
    );
  }
}