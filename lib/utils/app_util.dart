import 'dart:io';

import 'package:app_tool/extensions/export_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'log_util.dart';

class AppUtil {
  static late PackageInfo packageInfo;

  ///  APP 信息
  static Future<void> getPackageInfo() async {
    // if (packageInfo == null) {
    packageInfo = await PackageInfo.fromPlatform();
    logU.v(Platform.operatingSystem);
    logU.v(
        'APP info :  version==> ${packageInfo.version}  packageName==> ${packageInfo.packageName}');
    // }
  }

  /// APP 文本复制
  static void copy(String? text, {String? tipText}) {
    if (text.isnull) {
      return;
    }
    final ClipboardData data = ClipboardData(text: text);
    Clipboard.setData(data);
  }

  /// APP 文本粘贴
  static Future<String?> paste() async {
    //获取粘贴板中的文本
    String? text;
    await Clipboard.getData(Clipboard.kTextPlain).then((v) {
      text = v?.text;
      return text;
    });
    return text;
  }

  /// APP 收起键盘
  static void keyBoardHide() {
    if (Get.context != null) {
      final FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }
  }

  /// APP 启动网页
  static Future<void> launchURL(String url,
      {LaunchMode mode = LaunchMode.platformDefault}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: mode);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// APP 强制调起系统键盘
  void showKeyBoard({bool show = true}) {
    if (show) {
      SystemChannels.textInput.invokeMethod('TextInput.show');
    } else {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      // close();
    }
  }
}
