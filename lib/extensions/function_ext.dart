// ignore_for_file: strict_raw_type, prefer_function_declarations_over_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// VoidCallback 扩展函数
extension VoidCallbackExt on VoidCallback {
  /// 函数防抖
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  VoidCallback debounce([
    Duration delay = const Duration(milliseconds: 300),
  ]) {
    Timer? timer;
    final VoidCallback target = () {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, () {
        this.call();
      });
    };
    return target;
  }

  /// 函数节流
  ///
  /// [func]: 要执行的方法
  VoidCallback throttle(
    Future Function() func,
  ) {
    if (func == null) {
      return func;
    }
    bool enable = true;
    final VoidCallback target = () {
      if (enable == true) {
        enable = false;
        func().then((_) {
          enable = true;
        });
      }
    };
    return target;
  }

  /// 隐藏键盘
  ///
  /// [func]: 要执行的方法
  VoidCallback? hide(Function func) {
    VoidCallback target = () {
      if (Get.context != null) {
        final FocusScopeNode currentFocus = FocusScope.of(Get.context!);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      }
      func.call();
    };
    return target;
  }
}

extension FunctionExt<T> on Function(T) {
  ///[func] 是否为空
  ///
  ///
  bool get isnull {
    if (this == null) {
      return true;
    } else {
      return false;
    }
  }
}
