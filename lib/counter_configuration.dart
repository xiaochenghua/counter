import 'package:flutter/material.dart';

enum IconStyle {
  add_minus,
  add_minus_bold,
  add_minus_circle,
  arrow,
  arrow_bold,
  arrow_double,
  arrow_circle,
  arrow_filling,
  direction,
}

abstract class CounterConfiguration {
  abstract final double size;

  abstract final double fontSize;

  abstract final Color textColor;

  abstract final double textWidth;

  abstract final IconStyle iconStyle;

  abstract final Color iconColor;

  abstract final Color disableColor;

  abstract final Color backgroundColor;

  abstract final double iconBorderWidth;

  abstract final double iconBorderRadius;
}

class DefaultCounterConfiguration implements CounterConfiguration {
  @override
  double get size => 25;

  @override
  double get fontSize => 20;

  @override
  Color get textColor => Colors.black;

  @override
  double get textWidth => 40;

  @override
  IconStyle get iconStyle => IconStyle.add_minus;

  @override
  Color get iconColor => Colors.black54;

  @override
  Color get disableColor => Colors.black12;

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get iconBorderWidth => 0;

  @override
  double get iconBorderRadius => size / 2;
}
