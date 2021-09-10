library counter;

import 'dart:math';
import 'package:flutter/material.dart';
import './configuration.dart';
import './r.dart';

class Counter extends StatefulWidget {
  Counter({
    required this.min,
    required this.max,
    this.initial,
    this.bound,
    this.step = 1,
    Configuration? configuration,
    this.onValueChanged,
    Key? key,
  })  : assert(min < max),
        assert(initial == null || (initial >= min && initial <= max)),
        assert(bound == null || (bound >= min && bound <= max)),
        assert(initial == null || bound == null || initial >= bound),
        assert(step > 0),
        configuration = configuration ?? DefaultConfiguration(),
        super(key: key);

  /// 最小值
  final num min;

  /// 最大值
  final num max;

  /// 初始值，如果初始值为null或无效，则初始值为[min]最小值
  final num? initial;

  /// 限制值
  /// Value和[initial]不能在([min], [bound])之间
  /// 但可以是=[min]或=[bound]
  final num? bound;

  /// 步进，每次+/- Value变化数值，必须是正数
  final num step;

  /// 外观配置
  final Configuration configuration;

  /// Value值改变回调
  final ValueChanged<num>? onValueChanged;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  /// 当前值
  late num _value;

  /// 最小值
  late final num _min;

  /// 最大值
  late final num _max;

  /// - 是否可用
  bool _decreaseEnable = false;

  /// + 是否可用
  bool _increaseEnable = false;

  /// 配置
  late final _configuration;

  /// 圆角
  late final _borderRadius;

  @override
  void initState() {
    super.initState();
    _min = widget.min;
    _max = widget.max;
    _configuration = widget.configuration;
    final r = _configuration.iconBorderRadius;
    final radius = r != null && r > 0 && r <= _configuration.size ? r : 0.0;
    _borderRadius = BorderRadius.circular(radius);
    _setValue(widget.initial ?? _min);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _decreaseEnable || _increaseEnable
        ? _configuration.textColor
        : _configuration.disableColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        _backend(),
        Text(
          _value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: _configuration.fontSize,
            color: textColor,
          ),
        )
      ],
    );
  }

  /// 背后控件，上层控件则是Text，用于展示Value
  Widget _backend() {
    final size = _configuration.size;
    final leftColor = _decreaseEnable
        ? _configuration.iconColor
        : _configuration.disableColor;
    final rightColor = _increaseEnable
        ? _configuration.iconColor
        : _configuration.disableColor;

    Widget? left;
    Widget? right;

    switch (_configuration.iconStyle) {
      case IconStyle.add_minus:
        left = _image(R.minus, leftColor);
        right = _image(R.add, rightColor);
        break;
      case IconStyle.add_minus_bold:
        left = _image(R.minus_bold, leftColor);
        right = _image(R.add_bold, rightColor);
        break;
      case IconStyle.add_minus_circle:
        left = _image(R.minus_circle, leftColor);
        right = _image(R.add_circle, rightColor);
        break;
      case IconStyle.arrow:
        left = _image(R.arrow_right, leftColor, rotate: true);
        right = _image(R.arrow_right, rightColor);
        break;
      case IconStyle.arrow_bold:
        left = _image(R.arrow_left_bold, leftColor);
        right = _image(R.arrow_left_bold, rightColor, rotate: true);
        break;
      case IconStyle.arrow_double:
        left = _image(R.arrow_double_left, leftColor);
        right = _image(R.arrow_double_left, rightColor, rotate: true);
        break;
      case IconStyle.arrow_circle:
        left = _image(R.arrow_left_circle, leftColor);
        right = _image(R.arrow_left_circle, rightColor, rotate: true);
        break;
      case IconStyle.arrow_filling:
        left = _image(R.arrow_left_filling, leftColor);
        right = _image(R.arrow_left_filling, rightColor, rotate: true);
        break;
      case IconStyle.direction:
        left = _image(R.direction_left, leftColor);
        right = _image(R.direction_left, rightColor, rotate: true);
        break;
    }

    final spacing = 5.0;

    return Container(
      width: 2 * size + 2 * spacing + _configuration.textWidth,
      height: size,
      color: _configuration.backgroundColor,
      child: Row(
        children: [
          InkWell(
            onTap: _decreaseEnable ? () => _increase(-widget.step) : null,
            borderRadius: _borderRadius,
            child: left,
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _configuration.textBackgroundColor,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          SizedBox(width: spacing),
          InkWell(
            onTap: _increaseEnable ? () => _increase(widget.step) : null,
            borderRadius: _borderRadius,
            child: right,
          ),
        ],
      ),
    );
  }

  /// 返回一个Widget，
  /// [rotate]-是否需要180度顺时针翻转
  Widget _image(String name, Color? color, {bool rotate = false}) {
    final size = _configuration.size;
    final imageSize = size * 4 / 5;
    final borderWidth = _configuration.iconBorderWidth;
    final border = borderWidth != null && borderWidth > 0 && color != null
        ? Border.all(
            color: color,
            width: borderWidth,
          )
        : null;
    final sizedbox = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(border: border, borderRadius: _borderRadius),
      child: Center(
        child: Image.asset(
          name,
          width: imageSize,
          height: imageSize,
          color: color,
          fit: BoxFit.contain,
          package: R.package,
        ),
      ),
    );
    if (!rotate) return sizedbox;
    return Transform.rotate(angle: pi, child: sizedbox);
  }

  /// 增长预判，[increase]可以是负数，表明动作是decrease
  void _increase(num increase) {
    if (increase == 0) return;
    final expected = _value + increase;
    if (expected < _min || expected > _max) return;
    _setValue(expected);
  }

  /// 设置值，[expected]为预期值，不能保证和实际相同
  void _setValue(num expected) {
    final bound = widget.bound;
    num value = expected;

    // bound处理
    if (bound != null && expected > _min && expected < bound) {
      // min < 预期值 < bound，根据+/-将值改为bound或min
      if (_value > expected) {
        value = _min;
      } else {
        value = bound;
      }
    }

    // 设值
    setState(() {
      _value = value;
      _decreaseEnable = _value - widget.step >= _min;
      _increaseEnable = _value + widget.step <= _max;
    });

    // 执行回调
    widget.onValueChanged?.call(_value);
  }
}
