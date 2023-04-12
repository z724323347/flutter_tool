import 'package:app_tool/extensions/export_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// log日志 ctrl控制器
class LogsEventSer extends GetxService {
  /// Ctrl instance
  static LogsEventSer get to => GetInstance().putOrFind(() => LogsEventSer());

  /// 是否开启
  final open = false.obs;

  final listLog = RxList<LogsEvent>([]);

  @override
  void onInit() {
    clearLog();
    if (!kReleaseMode) {
      setOpen(true);
    }
    super.onInit();
  }

  void setOpen(bool status) {
    open.value = status;
  }

  void add(LogsEvent event) {
    if (!open.value) {
      return;
    }
    listLog.insert(0, event);
  }

  void clearLog() {
    listLog.clear();
  }
}

class LogsEvent {
  /// 类型
  int? type;

  /// 时间
  String? time;

  /// 信息
  String? msg;

  /// 文件
  String? file;

  /// 断点信息
  String? breakpoint;

  LogsEvent({this.type, this.time, this.msg, this.file, this.breakpoint});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'file': file,
      'breakpoint': breakpoint,
      'time': time?.dateTime.hmsDotSS,
      'msg': msg,
    }..removeWhere((k, v) => v == null);
  }
}
