// ignore_for_file: cast_nullable_to_non_nullable

import '../utils/log_util.dart';

/// object 扩展函数
extension AppObj on Object? {
  /// object 转 map , 主要使用在路由传参
  Map<String, dynamic> get toMap {
    Map<String, dynamic> data = {};
    if (this == null) {
      return {};
    }
    if (this is Map) {
      // object 为空map
      if (toString() == '{}') {
        return {};
      }
      data = this as Map<String, dynamic>;
    }
    return data;
  }

  bool equals(dynamic data) {
    if (this == null && data != null) {
      return false;
    }
    return this == data;
  }
}

extension DynamicExt<T> on dynamic {
  int get toInt {
    if (this == null || this is! num) {
      return 0;
    }
    try {
      if (this is int) {
        return int.parse('$this');
      }
      if (this is double) {
        return int.parse('$this');
      }
      if (this is String) {
        return int.parse(this);
      }
    } catch (e) {
      logU.e(e);
    }
    return 0;
  }
}
