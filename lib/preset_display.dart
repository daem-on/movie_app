import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LookPresetTag {
  movieBackdrop
}

class LookPreset {
  final Gradient? gradient;
  final Gradient? borderGradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? radius;
  final TextStyle? defaultTextStyle;
  final Color? accentColor;
  final ImageProvider? topImage;
  final ImageProvider? bottomImage;
  final EdgeInsetsGeometry? extraPadding;
  final LookPresetTag? tag;

  bool get doubleContainer => borderGradient != null;
  bool get hasSolidBorder => borderColor != null;
  bool get stacked => topImage != null || bottomImage != null;
  bool get onBottom => bottomImage != null;

  const LookPreset({
    this.gradient,
    this.borderGradient,
    this.backgroundColor,
    this.borderColor,
    this.radius,
    this.defaultTextStyle,
    this.accentColor,
    this.topImage,
    this.bottomImage,
    this.extraPadding,
    this.tag
  });
}

const _topDownGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF000000), Color(0x00000000)],
);
const _reversedGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [Color(0xFF000000), Color(0x00000000)],
);
const _brightTopGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF000000), Color(0x3C000000), Color(0x00000000)],
);

class PresetDisplay extends StatelessWidget {
  const PresetDisplay(
      {Key? key,
      required this.child,
      required this.preset,
      this.padding,
      this.topImage})
      : super(key: key);

  final Widget child;
  final LookPreset preset;
  final EdgeInsetsGeometry? padding;
  final ImageProvider? topImage;
  bool get stacked => preset.stacked || topImage != null;

  @override
  Widget build(BuildContext context) {
    if (preset.doubleContainer) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: preset.radius,
            gradient: preset.borderGradient,
          ),
          child: _buildInner(context));
    } else {
      return _buildInner(context);
    }
  }

  Widget _buildInner(BuildContext context) {
    return Container(
        margin: preset.doubleContainer ? const EdgeInsets.all(10) : null,
        padding: stacked ? null : padding,
        decoration: BoxDecoration(
          borderRadius: preset.radius,
          gradient: preset.gradient,
          color: preset.backgroundColor,
          border: preset.hasSolidBorder
              ? Border.all(color: preset.borderColor!)
              : null,
        ),
        child: preset.defaultTextStyle != null
            ? DefaultTextStyle(
                style: preset.defaultTextStyle!, child: _buildStack(context))
            : _buildStack(context));
  }

  Widget _buildStack(BuildContext context) {
    if (stacked) {
      return Stack(
        alignment: preset.onBottom ? Alignment.bottomCenter : Alignment.topCenter,
        children: [
          Positioned(
            child: ClipRRect(
              borderRadius: preset.radius,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return (preset.onBottom ? _reversedGradient : _topDownGradient)
                      .createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height)
                  );
                },
                blendMode: BlendMode.dstIn,
                child: Image(
                  image: preset.topImage ?? preset.bottomImage ?? topImage!)
              ),
            ),
          ),
          Padding(
            padding: (padding ?? EdgeInsets.zero)
                .add(preset.extraPadding ?? EdgeInsets.zero),
            child: _buildWithWatermark(context),
          ),
        ],
      );
    } else {
      return _buildWithWatermark(context);
    }
  }

  Widget _buildWithWatermark(BuildContext context) {
    return Column(
      children: [
        child,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Made with"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                child: Icon(CupertinoIcons.film),
                foregroundColor: CupertinoColors.white,
                backgroundColor: Color(0x88000000),
              ),
            ),
            Text("movie_app"),
          ],
        ),
      ],
    );
  }
}
