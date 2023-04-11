import 'dart:async';

import 'package:flutter/services.dart';

class AppTool {
  static const MethodChannel _channel = const MethodChannel('app_tool');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
