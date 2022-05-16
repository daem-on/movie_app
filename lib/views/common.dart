/// All the components which are reused between libraries.
library common;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/screenshot_share.dart';

import '../../presets/presets.dart';
import '../data/model.dart';
import '../data/tmdb.dart';
import '../preset_display.dart';

/// A container with round corners.
///
/// Since `flutter/cupertino` doesn't have a standard conatiner,
/// we have to make a custom one.
///
/// ![Two CupertinoContainers on a page](https://github.com/daem-on/movie_app/raw/master/doc_assets/toplist_settings.png)
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

/// A modal view which shows a [CupertinoPicker], with a select button.
/// Use with [showCupertinoModalPopup].
class PickerModal extends StatelessWidget {
  PickerModal({
    Key? key,
    required this.options,
    this.button = "Select",
    int? initialItem,
  }) : super(key: key) {
    _controller = FixedExtentScrollController(initialItem: initialItem ?? 0);
  }

  /// List of the options to be displayed. Use `initialItem` to show one already
  /// selected.
  final List<String> options;
  late final FixedExtentScrollController _controller;
  /// The label of the button.
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

/// A modal view which shows a [CupertinoDatePicker], with a button to set
/// and to clear the value.
/// Use with [showCupertinoModalPopup].
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

/// A modal view which shows a [CupertinoTimerPicker], with a button to set
/// and to clear the value.
/// Use with [showCupertinoModalPopup].
// Actually I agree that this should not be immutable but it works fine
// and doesn't use setState() at all. Also it's not my fault the timepicker
// doesn't have a controller
// ignore: must_be_immutable
class DurationModal extends StatelessWidget {
  DurationModal({
    Key? key,
    required this.value
  }) : super(key: key);

  /// Initial value for the picker.
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

/// A row of a settings UI. Use with [CupertinoContainer].
///
/// Contains a line of text, optionally two, an icon at the end, and will call
/// a callback when pressed.
///
/// ![Multiple SettingRows in the top container](https://github.com/daem-on/movie_app/raw/master/doc_assets/toplist_settings.png)
class SettingRow extends StatelessWidget {
  /// The icon to show at the end of the row.
  final Icon icon;
  /// Callback when pressed.
  final void Function()? onPressed;
  final String text;
  /// Optional second line of text.
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
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                if (secondText != null)
                  Text(
                    secondText!,
                    style: CupertinoTheme.of(context).textTheme.actionTextStyle,
                    overflow: TextOverflow.fade,
                    softWrap: false
                  )
              ],
            ),
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

/// A reusable widget to create a scaffold, a navbar, and
/// safe area that is used for each view.
class MovieAppScaffold extends StatelessWidget {
  final Widget child;
  /// The trailing widget of the navigation bar. Use a [TrailingButton],
  /// or leave empty.
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

/// A button to use as the trailing widget in a [CupertinoNavigationBar].
///
/// Looks very similar to the navigation bar's back button, so a view
/// with a back and forward button will look symmetrical.
///
/// ![An example of TrailingButton at the top](https://github.com/daem-on/movie_app/raw/master/doc_assets/awards_appearance.png)
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

/// A button which is shown at the bottom center of the screen.
/// Should be used in a [Stack]
///
/// ![Example on the bottom](https://github.com/daem-on/movie_app/raw/master/doc_assets/filmography_preview.png)
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

/// A container with given content, which enables the user to share a
/// screenshot of the content with a button at the bottom.
///
/// ![Example with Filmography](https://github.com/daem-on/movie_app/raw/master/doc_assets/filmography_preview.png)
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
              screenshotShare(previewContainerKey);
            },
            text: "Share",
            icon: const Icon(CupertinoIcons.share))
      ]),
    );
  }
}

/// Shows a movie poster for a given [Movie] from TMDB. Not interactive.
///
/// Has rounded corners and a placeholder when there is no poster.
///
/// <img title="Example in a Filmography"
/// src="https://github.com/daem-on/movie_app/raw/master/doc_assets/filmography.png"
/// width=300
/// />
class MoviePosterSimple extends StatelessWidget {
  final Movie movie;
  /// Optional width of the displayed poster.
  final double? width;
  /// Width of the image which will be loaded from TMDB.
  /// Has to be one of TMDB specified widths.
  final int posterWidth;
  /// Use text as placeholder instead of icon.
  final bool placeholderText;

  const MoviePosterSimple(this.movie, {
    this.width = 154,
    this.posterWidth = 92,
    this.placeholderText = false,
    Key? key}) : super(key: key);

  BorderRadius get _br => BorderRadius.circular((width ?? 154) / 10);

  @override
  Widget build(BuildContext context) {
    return (movie.poster != null)
    ? Center(
      child: ClipRRect(
        borderRadius: _br,
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
          decoration: BoxDecoration(
            color: CupertinoColors.tertiarySystemGroupedBackground,
            borderRadius: _br,
          ),
          child: placeholderText
              ? Center(child: Text(movie.fullTitle))
              : const Center(child: Icon(CupertinoIcons.film)),
        ),
      ),
    );
  }
}

/// Shows the profile image of a [Person] from TMDB.
///
/// <img title="Example in a Filmography"
/// src="https://github.com/daem-on/movie_app/raw/master/doc_assets/filmography.png"
/// width=300
/// />
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

/// 5-star rating slider.
///
/// {@animation example 300 400 https://github.com/daem-on/movie_app/raw/master/doc_assets/filmography_ratings.webm}
class StarRatingSlider extends StatelessWidget {
  const StarRatingSlider({
    Key? key,
    required this.rating, required this.callback,
  }) : super(key: key);

  /// Current value in number of half stars.
  final int rating;
  /// Called when a new value is set.
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

/// 5-star rating slider with a minimum of half a star. See [StarRatingSlider].
class NonNullStarRatingSlider extends StatelessWidget {
  const NonNullStarRatingSlider({
    Key? key,
    required this.rating, required this.callback,
  }) : super(key: key);

  /// Current value in number of half stars.
  final int rating;
  /// Called when a new value is set.
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
      ],
    );
  }
}

/// A modal view which shows a [CupertinoActionSheet], created from a list of
/// options of type [T].
/// Use with [showCupertinoModalPopup].
class OptionsModal<T> extends StatelessWidget {
  const OptionsModal({
    Key? key,
    required this.options, required this.title,
  }) : super(key: key);

  /// A map of the options to choose between. Key is the text which will
  /// be displayed to the user, value will be returned as the result.
  final Map<String, T> options;
  /// A title to show at the top of the modal.
  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
          title,
          style: const TextStyle(fontSize: 24)
      ),
      actions: [
        for (final element in options.entries)
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(element.value);
              },
              child: Text(element.key)
          )
      ],
    );
  }
}

/// A setting row which allows for selecting a [LookPreset] from a list of
/// presets.
class AppearanceSelectorRow extends StatelessWidget {
  final void Function(LookPreset) callback;
  final LookPreset current;
  /// The map of options. The key will be displayed to users.
  final Map<String, LookPreset> options;
  const AppearanceSelectorRow({Key? key, required this.callback, required this.current, this.options = lookPresets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _lookPresetsInv = lookPresets.map((key, value) => MapEntry(value, key));
    return CupertinoFormRow(
      prefix: const Text("Appearance preset"),
      child: CupertinoButton(
        onPressed: () async {
          LookPreset? result = await showCupertinoModalPopup(
              context: context,
              semanticsDismissible: true,
              builder: (context) => OptionsModal<LookPreset>(
                  options: options,
                  title: "Pick preset"
              )
          );
          if (result == null) return;
          callback(result);
        },
        child: Text(_lookPresetsInv[current] ?? "Other"),
      ),
    );
  }
}
