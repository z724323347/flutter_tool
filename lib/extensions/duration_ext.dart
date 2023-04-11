import '../utils/log_util.dart';

/// 时间 datetime 扩展函数
extension AppDuration on Duration {
  String get hms {
    final int all = inSeconds;
    if (all < 0) {
      return '';
    }
    final int d = all ~/ (60 * 60 * 24);
    final int h = (all ~/ (60 * 60)) % 24;
    final int m = (all ~/ 60) % 60;
    final int s = all % 60;

    return '${(h < 10 && h > 0) ? '0$h' : '$h'}:${m < 10 ? '0$m' : '$m'}:${s < 10 ? '0$s' : '$s'}';
  }

  /// 是否已经过期
  ///
  /// 已过期：true
  ///
  /// 未过期：false
  ///
  /// Duration > 0 未过期， Duration < 0 已过期
  bool get overdue {
    if (this == null) {
      return true;
    }
    if (this > Duration.zero) {
      return false;
    } else {
      return true;
    }
  }

  /// 转换为（中文）  xx天xxs时xx分xx秒
  String get dhmsFormat {
    final int all = inSeconds;
    if (all < 0) {
      return '';
    }
    final int d = all ~/ (60 * 60 * 24);
    final int h = (all ~/ (60 * 60)) % 24;
    final int m = (all ~/ 60) % 60;
    final int s = all % 60;

    return '${(d < 10 && d > 0) ? '0$d天' : '$d天'}:${h < 10 ? '0$h时' : '$h时'}:${m < 10 ? '0$m分' : '$m分'}:${s < 10 ? '0$s秒' : '$s秒'}';
  }

  /// 转换为（中文）  xx分xx秒
  String get ms {
    final int all = inSeconds;
    if (all < 0 || all == 0) {
      return '0 秒';
    }
    final int m = all ~/ 60;
    final int s = all % 60;

    return '${m < 10 ? '0$m 分' : '$m 分'} ${s < 10 ? '0$s 秒' : '$s 秒'}';
  }

  /// Duration 转 毫秒
  String get msec {
    if (this == null) {
      return '0 ms';
    }
    String _str = '';
    final int all = inMilliseconds;
    final int s = all ~/ (60 * 1000);
    final int ms = all % (60 * 1000);

    try {
      _str = '${s * 1000 + ms} ms';
    } catch (e) {
      logs(e);
    }
    return _str;
  }
}
