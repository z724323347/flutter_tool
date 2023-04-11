import 'dart:ui' as ui show window;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen {
  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  static double get width {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.width;
  }

  static double get height {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.height;
  }

  static double get scale {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.devicePixelRatio;
  }

  static double get textScaleFactor {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.textScaleFactor;
  }

  static double get topSafeHeight {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top;
  }

  static double get bottomSafeHeight {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.bottom;
  }

  static void updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static double get scrollTitleBackBarHeight => 50;

  static double get commonTitleBarHeight => 50;

  static double get appbarBottomHegiht => 40;

  static double getScaleSp(BuildContext context, double fontSize) {
    if (getScreenW(context) == 0.0) {
      return fontSize;
    }
    return fontSize * getScreenW(context) / 375;
  }

  /// screen width
  /// 当前屏幕 宽
  static double getScreenW(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width;
  }
}
