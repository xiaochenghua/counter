import 'package:flutter/material.dart';

abstract class CounterConfiguration {
  abstract final double size;

  abstract final Color textColor;

  abstract final Color iconColor;

  abstract final Color disableColor;

  abstract final Color backgroundColor;

  abstract final double iconBorderWidth;

  abstract final double iconBorderRadius;
}

class DefaultCounterConfiguration implements CounterConfiguration {
  @override
  double get size => 30;

  @override
  Color get textColor => Colors.black;

  @override
  Color get iconColor => Colors.black87;

  @override
  Color get disableColor => Colors.black26;

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get iconBorderWidth => 0;

  @override
  double get iconBorderRadius => size / 2;
}
