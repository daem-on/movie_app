import 'package:flutter/cupertino.dart';

class LookPreset {
  final Gradient? gradient;
  final Gradient? borderGradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? radius;
  final TextStyle? defaultTextStyle;
  final Color? accentColor;

  bool get doubleContainer => borderGradient != null;
  bool get hasSolidBorder => borderColor != null;

  const LookPreset({
      this.gradient,
      this.borderGradient,
      this.backgroundColor,
      this.borderColor,
      this.radius,
      this.defaultTextStyle,
      this.accentColor
  });
}

class PresetDisplay extends StatelessWidget {
  const PresetDisplay({Key? key, required this.child, required this.preset, this.padding})
      : super(key: key);

  final Widget child;
  final LookPreset preset;
  final EdgeInsetsGeometry? padding;

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
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: preset.radius,
          gradient: preset.gradient,
          color: preset.backgroundColor,
          border: preset.hasSolidBorder
              ? Border.all(color: preset.borderColor!)
              : null,
        ),
        child: preset.defaultTextStyle != null
            ? DefaultTextStyle(style: preset.defaultTextStyle!, child: child)
            : child);
  }
}
