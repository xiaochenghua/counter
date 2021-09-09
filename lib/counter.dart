library counter;

import 'dart:math';
import 'package:flutter/material.dart';
import './counter_configuration.dart';
import './counter_icons.dart';

class Counter extends StatefulWidget {
  Counter({
    required this.min,
    required this.max,
    this.initial,
    this.bound,
    this.step = 1,
    // this.size = 30,
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

  // /// height and icon width
  // final double size;

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
    // final size = configuration.size;
    // final leftColor =
    //     decreaseEnable ? configuration.iconColor : configuration.disableColor;
    // final rightColor =
    //     increaseEnable ? configuration.iconColor : configuration.disableColor;
    final textColor = decreaseEnable || increaseEnable
        ? configuration.textColor
        : configuration.disableColor;
    // return Container(
    //   height: size,
    //   width: size * 2 + 40,
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       InkWell(
    //         onTap: decreaseEnable ? () => _increase(-widget.step) : null,
    //         borderRadius: BorderRadius.circular(size / 2),
    //         child: SizedBox(
    //           width: size,
    //           height: double.infinity,
    //           child: Icon(Icons.remove, color: leftColor),
    //         ),
    //       ),
    // Expanded(
    //   child: Center(
    //     child: Text(
    //       _value.toString(),
    //       style: TextStyle(
    //         fontSize: configuration.fontSize,
    //         color: textColor,
    //       ),
    //     ),
    //   ),
    // ),
    //       InkWell(
    //         onTap: increaseEnable ? () => _increase(widget.step) : null,
    //         borderRadius: BorderRadius.circular(size / 2),
    //         child: SizedBox(
    //           width: size,
    //           height: double.infinity,
    //           child: Icon(Icons.add, color: rightColor),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

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
    final children = <Widget>[];
    switch (configuration.iconStyle) {
      case IconStyle.add_minus:
        children.addAll([
          Icon(
            CounterIcons.minus,
            size: size,
            color: leftColor,
          ),
          Icon(
            CounterIcons.add,
            size: size,
            color: rightColor,
          )
        ]);
        break;
      case IconStyle.add_minus_bold:
        children.addAll([
          Icon(
            CounterIcons.minus_bold,
            size: size,
            color: leftColor,
          ),
          Icon(
            CounterIcons.add_bold,
            size: size,
            color: rightColor,
          )
        ]);
        break;
      case IconStyle.add_minus_circle:
        children.addAll([
          Icon(
            CounterIcons.minus_circle,
            size: size,
            color: leftColor,
          ),
          Icon(
            CounterIcons.add_circle,
            size: size,
            color: rightColor,
          )
        ]);
        break;
      case IconStyle.arrow:
        children.addAll([
          Transform.rotate(
            angle: pi,
            child: Icon(
              CounterIcons.arrow_right,
              size: size,
              color: leftColor,
            ),
          ),
          Icon(
            CounterIcons.arrow_right,
            size: size,
            color: rightColor,
          )
        ]);
        break;
      case IconStyle.arrow_bold:
        children.addAll([
          Icon(
            CounterIcons.arrow_left_bold,
            size: size,
            color: leftColor,
          ),
          Transform.rotate(
            angle: pi,
            child: Icon(
              CounterIcons.arrow_left_bold,
              size: size,
              color: rightColor,
            ),
          )
        ]);
        break;
      case IconStyle.arrow_double:
        children.addAll([
          Icon(
            CounterIcons.arrow_double_left,
            size: size,
            color: leftColor,
          ),
          Transform.rotate(
            angle: pi,
            child: Icon(
              CounterIcons.arrow_double_left,
              size: size,
              color: rightColor,
            ),
          )
        ]);
        break;
      case IconStyle.arrow_circle:
        children.addAll([
          Icon(
            CounterIcons.arrow_left_circle,
            size: size,
            color: leftColor,
          ),
          Transform.rotate(
            angle: pi,
            child: Icon(
              CounterIcons.arrow_left_circle,
              size: size,
              color: rightColor,
            ),
          )
        ]);
        break;
      case IconStyle.arrow_filling:
        children.addAll([
          Icon(
            CounterIcons.arrow_left_filling,
            size: size,
            color: leftColor,
          ),
          Transform.rotate(
            angle: pi,
            child: Icon(
              CounterIcons.arrow_left_filling,
              size: size,
              color: rightColor,
            ),
          )
        ]);
        break;
      case IconStyle.direction:
        children.addAll([
          Icon(
            CounterIcons.direction_left,
            size: size,
            color: leftColor,
          ),
          Transform.rotate(
            angle: pi,
            child: Icon(
              CounterIcons.direction_left,
              size: size,
              color: rightColor,
            ),
          )
        ]);
        break;
    }

    final sizedboxs = children
        // .map(
        //   (e) => SizedBox(
        //     width: size,
        //     height: double.infinity,
        //     child: e,
        //   ),
        // )
        .toList();

    final gestures = <InkWell>[];

    for (var i = 0; i < sizedboxs.length; i++) {
      final onTap = i == 0
          ? (decreaseEnable ? () => _increase(-widget.step) : null)
          : (increaseEnable ? () => _increase(widget.step) : null);

      gestures.add(
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: sizedboxs[i],
        ),
      );
    }

    // Inkwell

    return Container(
      width: 2 * size + configuration.textWidth,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: gestures,
      ),
    );
  }
}
