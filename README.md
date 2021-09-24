# counter

[简体中文](https://github.com/xiaochenghua/counter/blob/master/README_CN.md)

A Flutter counter widget, supports min/max/initial/bound/step value with type num, and supports appearance configuration.

## Getting Started

1. Add dependency to ```pubspec.yaml```, and run ```flutter pub get```

```yaml
counter: ^0.2.2
```

2. import the package

```dart
import 'package:counter/counter.dart';
```

3. expample code

```dart
Counter(
  /// min value
  min: 0,
  
  /// max value
  max: 10,

  /// bound value, default null，must be greater than or equal to [min] and less than or equal to [max].
  /// current value can not be greater than [min] and less than bound if bound is not null and its approved.
  /// if current value is [min], and bound value greater than [min] too, and the value will be change with bound value by one step after inscrease button clicked.
  /// and it will be change with [min] value by one step after descrease button clicked.
  bound: 3,

  /// initial value, default equal to [min], must be greater than or equal to [min] and less than or equal to [max].
  /// and initial value must be greater or equal to [bound], while bound and initial value both not be null.
  initial: 5,
  
  /// stepper，default 1
  step: 1,
  
  /// appearance configuration，default DefaultConfiguration()
  /// you can also set up custom appearance by implements [Configuration] class.
  configuration: DefaultConfiguration(),
  
  /// value changed callback.
  onValueChanged: print,
)
```


4. feature support

- [x] support type num(include int/double) values.

- [x] support min/max/initial/bound values.

- [x] support set up custom appearance.

- [x] support value changed callback.

  will soon...

- [ ] type in value from keyboard

