library counter;

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({
    required this.min,
    required this.max,
    this.initial,
    this.bound,
    this.step = 1,
    this.size = 30,
    this.onValueChanged,
    Key? key,
  })  : assert(min < max),
        assert(initial == null || (initial >= min && initial <= max)),
        assert(bound == null || (bound >= min && bound <= max)),
        assert(initial == null || bound == null || initial >= bound),
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

  /// height and icon width
  final double size;

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
  Widget build(BuildContext context) => Container(
        height: widget.size,
        width: widget.size * 2 + 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: decreaseEnable ? () => _increase(-widget.step) : null,
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: SizedBox(
                width: widget.size,
                height: double.infinity,
                child: Icon(
                  Icons.remove,
                  color: decreaseEnable ? Colors.orange : Colors.orange[200],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  _value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: increaseEnable ? () => _increase(widget.step) : null,
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: SizedBox(
                width: widget.size,
                height: double.infinity,
                child: Icon(
                  Icons.add,
                  color: increaseEnable ? Colors.orange : Colors.orange[200],
                ),
              ),
            ),
          ],
        ),
      );
}
