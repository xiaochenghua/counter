import 'package:flutter/material.dart';

/// Icon样式
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

abstract class Configuration {
  /// 尺寸，包括左右两侧控件宽高，InkWell水波纹直径等
  abstract final double size;

  /// 中间Text字体大小
  abstract final double fontSize;

  /// 中间Text文本颜色
  abstract final Color? textColor;

  /// 中间文本区域 背景颜色
  abstract final Color? textBackgroundColor;

  /// 中间文本区域 宽度
  abstract final double textWidth;

  /// Icon样式
  abstract final IconStyle iconStyle;

  /// Icon颜色，Enable状态
  abstract final Color? iconColor;

  /// Icon颜色，Disable状态
  abstract final Color? disableColor;

  /// Counter区域背景颜色
  abstract final Color? backgroundColor;

  /// Icon控件 边框大小
  abstract final double? iconBorderWidth;

  /// Icon控件 圆角
  abstract final double? iconBorderRadius;
}

class DefaultConfiguration implements Configuration {
  @override
  double get size => 25;

  @override
  double get fontSize => 20;

  @override
  Color? get textColor => Colors.black;

  @override
  Color? get textBackgroundColor => Colors.grey[200];

  @override
  double get textWidth => 40;

  @override
  IconStyle get iconStyle => IconStyle.add_minus;

  @override
  Color? get iconColor => Colors.black87;

  @override
  Color? get disableColor => Colors.black12;

  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  double? get iconBorderWidth => null;

  @override
  double? get iconBorderRadius => size / 2;
}
