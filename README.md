# counter

Flutter计数器，支持min/max/initial/bound/step，支持外观配置。

## Getting Started

1、添加依赖，```flutter pub get```

```yaml
counter: any
```

2、导入依赖

```dart
import 'package:counter/counter.dart';
```

3、特性支持

- [x] 支持int/double类型value

- [x] 支持最小/最大/初始/限制值类型

- [x] 支持外观只定义配置

- [x] 支持值改变回调

  即将支持...

- [ ] 自定义输入value

4、示例代码

```dart
Counter(
  /// 最小值
  min: 0,
  
  /// 最大值
  max: 10,

  /// 限制值，如果符合条件，值不可在(min, bound)之间
  /// 在min点击+之间一步跳至bound，在bound点击-一步跳至min
  /// 默认null，即不存在限制值，限制值只能在[min, max]之间
  bound: 3,

  /// 初始值，默认null，初始值有效区间[min, max]，且initial>=bound
  /// 如果是null则默认初始值为min
  initial: 5,
  
  /// 步进，默认为1 
  step: 1,
  
  /// 外观配置，默认DefaultConfiguration()，
  /// 实现Configuration抽象类可自定义外观配置
  configuration: DefaultConfiguration(),
  
  /// 值改变回调
  onValueChanged: print,
)
```

