library counter;

import 'dart:math';
import 'package:flutter/material.dart';
import './counter_configuration.dart';
import './r.dart';

class Counter extends StatefulWidget {
  Counter({
    required this.min,
    required this.max,
    this.initial,
    this.bound,
    this.step = 1,
    CounterConfiguration? configuration,
    this.onValueChanged,
    Key? key,
  })  : assert(min < max),
        assert(initial == null || (initial >= min && initial <= max)),
        assert(bound == null || (bound >= min && bound <= max)),
        assert(initial == null || bound == null || initial >= bound),
        configuration = configuration ?? DefaultCounterConfiguration(),
        super(key: key);

  /// min value.
  final num min;

  /// max value.
  final num max;

  /// initial value,
  /// If the value is invalid or null，default [min].
  final num? initial;

  /// min <= bound <= max
  final num? bound;

  /// the value of increase or decrease every change.
  final num step;

  /// Counter Configuration
  final CounterConfiguration configuration;

  /// value changed callback.
  final ValueChanged<num>? onValueChanged;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  /// current value.
  late num _value;

  bool decreaseEnable = false;
  bool increaseEnable = false;
  late final num min;
  late final num max;

  void _increase(num increase) {
    if (increase == 0) return;
    final expected = _value + increase;
    if (expected < min || expected > max) return;
    _setValue(expected);
  }

  void _setValue(num expected) {
    final bound = widget.bound;
    num value = expected;
    if (bound != null && expected > min && expected < bound) {
      // handle bound
      if (_value > expected) {
        value = min;
      } else {
        value = bound;
      }
    }

    // set value
    setState(() {
      _value = value;
      decreaseEnable = _value > min;
      increaseEnable = _value < max;
    });
    widget.onValueChanged?.call(_value);
  }

  @override
  void initState() {
    super.initState();
    min = widget.min;
    max = widget.max;
    _setValue(widget.initial ?? min);
  }

  @override
  Widget build(BuildContext context) {
    final configuration = widget.configuration;
    final textColor = decreaseEnable || increaseEnable
        ? configuration.textColor
        : configuration.disableColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        _backend(),
        Text(
          _value.toString(),
          style: TextStyle(
            fontSize: configuration.fontSize,
            color: textColor,
          ),
        )
      ],
    );
  }

  Widget _backend() {
    final configuration = widget.configuration;
    final size = configuration.size;
    final leftColor =
        decreaseEnable ? configuration.iconColor : configuration.disableColor;
    final rightColor =
        increaseEnable ? configuration.iconColor : configuration.disableColor;

    List<Widget> children;
    switch (configuration.iconStyle) {
      case IconStyle.add_minus:
        children = [
          _image(R.minus, leftColor),
          _image(R.add, rightColor),
        ];
        break;
      case IconStyle.add_minus_bold:
        children = [
          _image(R.minus_bold, leftColor),
          _image(R.add_bold, rightColor),
        ];
        break;
      case IconStyle.add_minus_circle:
        children = [
          _image(R.minus_circle, leftColor),
          _image(R.add_circle, rightColor),
        ];
        break;
      case IconStyle.arrow:
        children = [
          _image(R.arrow_right, leftColor, rotate: true),
          _image(R.arrow_right, rightColor),
        ];
        break;
      case IconStyle.arrow_bold:
        children = [
          _image(R.arrow_left_bold, leftColor),
          _image(R.arrow_left_bold, rightColor, rotate: true),
        ];
        break;
      case IconStyle.arrow_double:
        children = [
          _image(R.arrow_double_left, leftColor),
          _image(R.arrow_double_left, rightColor, rotate: true),
        ];
        break;
      case IconStyle.arrow_circle:
        children = [
          _image(R.arrow_left_circle, leftColor),
          _image(R.arrow_left_circle, rightColor, rotate: true),
        ];
        break;
      case IconStyle.arrow_filling:
        children = [
          _image(R.arrow_left_filling, leftColor),
          _image(R.arrow_left_filling, rightColor, rotate: true),
        ];
        break;
      case IconStyle.direction:
        children = [
          _image(R.direction_left, leftColor),
          _image(R.direction_left, rightColor, rotate: true),
        ];
        break;
    }

    final gestures = <InkWell>[];

    for (var i = 0; i < children.length; i++) {
      final onTap = i == 0
          ? (decreaseEnable ? () => _increase(-widget.step) : null)
          : (increaseEnable ? () => _increase(widget.step) : null);

      gestures.add(
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: children[i],
        ),
      );
    }

    return Container(
      width: 2 * size + configuration.textWidth,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: gestures,
      ),
    );
  }

  Widget _image(String name, Color color, {bool rotate = false}) {
    final size = widget.configuration.size;
    final image = Image.asset(
      name,
      width: size,
      height: size,
      color: color,
      package: R.package,
    );
    if (!rotate) return image;
    return Transform.rotate(angle: pi, child: image);
  }
}
