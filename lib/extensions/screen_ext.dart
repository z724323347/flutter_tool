import 'dart:math' show min;

import '../adapter/auto_size_util.dart';
import '../utils/screen_util.dart';

/// 屏幕像素  扩展函数
extension ScreenExt on num {
  /// 屏幕宽度适配
  double get w => this * (Screen.width / screenWidthDesign);

  /// 字体大小适配
  double get sp {
    final double _min = min(Screen.width, Screen.height);
    return this * (_min / screenWidthDesign);
  }
}
