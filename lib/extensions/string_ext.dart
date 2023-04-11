import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../utils/log_util.dart';
import '../utils/regexp_util.dart';

extension StringExtNull on String? {
  /// 字符是否为空
  bool get isnull {
    if (this == null || this!.isEmpty || this?.toLowerCase() == 'null') {
      return true;
    }
    return false;
  }

  /// 字符空安全
  String get safety {
    if (isnull) {
      return '';
    }
    return this!;
  }

  /// null 状态 带参数扩展  under：下划线  zero：0
  String with_([bool under = false, bool zero = false]) {
    if (under) {
      return '--';
    }
    if (zero) {
      return '0';
    }
    return safety;
  }
}

/// String 扩展函数
extension StringExt on String {
  static final RegExp pascalPattern = RegExp(r'[^0-9a-zA-Z]');
  static final RegExp snakePattern = RegExp(r'[^0-9a-z]');

  /// 限制小数位总长度[limit] = 2 ,  [trimZero] = false 不去掉多余的 0
  String limitLength([int limit = 2, bool trimZero = false]) {
    if (isnull) {
      return '';
    }
    if (trimZero) {
      return _trimZero(_limitTrimDecimal(this, limit));
    } else {
      return _limitTrimDecimal(this, limit);
    }
  }

  /// 字符是否为空
  bool get isnull {
    if (this == null || length == 0 || isEmpty || toLowerCase() == 'null') {
      return true;
    }
    return false;
  }

  /// 字符空安全
  String get safety {
    if (isnull) {
      return '';
    }
    return this;
  }

  /// 移除引号
  String get repQuotes {
    if (isnull) {
      return '';
    }
    return replaceAll('"', '');
  }

  /// string 转 double
  double get toDouble {
    if (this == null || length == 0 || isEmpty || toLowerCase() == 'null') {
      return 0.0;
    }
    try {
      return double.parse(this);
    } catch (e) {
      logs(e);
      return 0.0;
    }
  }

  /// string 转 int
  int get toInt {
    if (this == null || length == 0 || isEmpty || toLowerCase() == 'null') {
      return 0;
    }
    try {
      return int.parse(this);
    } catch (e) {
      logs(e);
      return 0;
    }
  }

  /// 防止文字自动换行
  String get fixLines {
    if (isnull) {
      return '';
    }
    return Characters(this).join('\u{200B}');
  }

  /// 文本最大长度 / 截取文本长度
  ///
  /// length 最大长度
  ///
  /// withDot 是否带有省略符...
  String fixLength([int length = 10, bool withDot = true]) {
    if (isnull) {
      return '';
    }
    if (this.length < length) {
      return this;
    }
    if (withDot) {
      return '${substring(0, length)}...';
    } else {
      return substring(0, length);
    }
  }

  /// string 追加字段
  String add(String? text) {
    if (isnull) {
      return text ?? '';
    }
    return this + (text ?? '');
  }

  /// 首字母大写
  String get capitalizeFirst {
    if (isEmpty || length < 2) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  ///转大写
  String get toUpper {
    return toUpperCase();
  }

  /// 转小写
  String get toLower {
    return toLowerCase();
  }

  /// 脱敏 -(信息脱敏等)
  String get desensy {
    if (this == null || isEmpty) {
      return '';
    }
    // 手机号脱敏
    if (phoneReg.hasMatch(this)) {
      return '${substring(0, 3)} **** ${substring(8, length)}';
    }
    // 身份证脱敏
    if (iDCardReg.hasMatch(this)) {
      return '${substring(0, 6)} ******** ${substring(length - 4, length)}';
    }

    // 银行卡脱敏
    if (bankReg.hasMatch(this)) {
      return '${substring(0, 4)} ******** ${substring(length - 4, length)}';
    }

    // 中文姓名
    if (RegExp(r'^(?:[\u4e00-\u9fa5·.]{2,16})$').hasMatch(this)) {
      if (length == 2) {
        return '${substring(0, 1)} *';
      } else {
        return '${substring(0, 1)} ** ${substring(length - 1, length)}';
      }
    }
    // 英文姓名
    if (RegExp(r'^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$').hasMatch(this)) {
      if (length == 1) {
        return this;
      } else if (length == 2) {
        return '${substring(0, 1)} *';
      } else {
        return '${substring(0, 1)} ** ${substring(length - 1, length)}';
      }
    }
    return this;
  }

  /// 昵称脱敏 -(信息脱敏等)
  String get nickDesensy {
    if (this == null || isEmpty) {
      return '';
    }

    if (length == 2) {
      return '${substring(0, 1)} *';
    } else if (length == 1) {
      return this;
    } else if (length == 3) {
      final int starLengt = length - 2;
      String star = '';
      for (var i = 0; i < starLengt; i++) {
        star += '*';
      }
      return '${substring(0, 1)} $star ${substring(length - 1, length)}';
    } else {
      final int starLengt = length - 2;
      String star = '';
      for (var i = 0; i < starLengt; i++) {
        // ignore: use_string_buffers
        star += '*';
      }
      return '${substring(0, 1)} $star ${substring(length - 1, length)}';
    }
  }

  /// 中间脱敏 -(信息脱敏等)
  String get desensyMiddle {
    if (this == null || isEmpty) {
      return '';
    }
    if (length < 10) {
      return this;
    } else {
      return '${substring(0, 5)}...${substring(length - 5, length)}';
    }
  }

  /// 是否包含中文字符
  bool get zhChar {
    final bool v = RegExp(
            r'^(?:[\u3400-\u4DB5\u4E00-\u9FEA\uFA0E\uFA0F\uFA11\uFA13\uFA14\uFA1F\uFA21\uFA23\uFA24\uFA27-\uFA29]|[\uD840-\uD868\uD86A-\uD86C\uD86F-\uD872\uD874-\uD879][\uDC00-\uDFFF]|\uD869[\uDC00-\uDED6\uDF00-\uDFFF]|\uD86D[\uDC00-\uDF34\uDF40-\uDFFF]|\uD86E[\uDC00-\uDC1D\uDC20-\uDFFF]|\uD873[\uDC00-\uDEA1\uDEB0-\uDFFF]|\uD87A[\uDC00-\uDFE0])')
        .hasMatch(this);
    return v;
  }

  /// 驼峰
  String get toPascalName {
    final List<String> parts = split(pascalPattern);
    for (int i = 0; i < parts.length; i++) {
      if (i == 0) {
        continue;
      }
      parts[i] = parts[i].capitalizeFirst;
    }

    return parts.join();
  }

  /// 蛇形
  String get toSnakeName {
    return splitMapJoin(snakePattern, onMatch: (Match match) {
      final String matchText = match.group(0)!;
      if (match.start > 0) {
        return '_$matchText';
      }
      return matchText;
    }).toLowerCase();
  }

  /// 抹除开头的0
  String get stripLeadingZeros {
    final RegExp pattern = RegExp(r'^0+');
    return replaceAll(pattern, '');
  }

  /// 抹除末尾的0
  String get stripTrailingZeros {
    if (!contains('.')) {
      return this;
    }
    final String trimmed = replaceAll(RegExp(r'0*$'), '');
    if (trimmed.endsWith('.')) {
      return trimmed.substring(0, trimmed.length - 1);
    }

    return trimmed;
  }

  DateTime get dateTime {
    if (isnull) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// string 类型转 Decimal
  Decimal get decimal {
    if (this == null) {
      return Decimal.zero;
    }
    if (this is int) {
      return Decimal.fromInt(this as int);
    }
    if (contains(',')) {
      return Decimal.parse(replaceAll(',', ''));
    } else {
      return Decimal.parse(this);
    }
  }

  ///限制小数点后位数
  String _limitTrimDecimal(String str, int limit) {
    if (limit == 0) {
      ///限制位数为0 不做判断
    } else {
      final dotIndex = str.lastIndexOf('.');
      final len = str.length;
      if (dotIndex != -1) {
        if (len - dotIndex - 1 > limit) {
          str = str.substring(0, 1 + dotIndex + limit);
        } else {
          //小数位小于限制的小数位不做处理
        }
      } else {
        //无小数点不做判断
      }
    }
    return str;
  }

  /// 清除数值中多余的小数点以及0
  String _trimZero(String? str) {
    if (str == null) {
      return '';
    }
    if (str.endsWith('.')) {
      return str.substring(0, str.length - 1);
    } else if (str.endsWith('0')) {
      final dotIndex = str.lastIndexOf('.');
      if (dotIndex != -1) {
        var nonZeroIndex = str.lastIndexOf(RegExp(r'[^0]{1,1}'));
        if (nonZeroIndex == -1 || nonZeroIndex == dotIndex) {
          nonZeroIndex = dotIndex - 1;
        }
        return str.substring(0, nonZeroIndex + 1);
      }
    }
    return str;
  }

  /// 千分位 格式化
  String get thousands {
    final format = NumberFormat('#,##0.00####', 'en_US');
    if (this == null) {
      return '0.00';
    }
    if (zhChar) {
      return this;
    }
    final number = Decimal.parse(this);
    if (number == Decimal.zero) {
      return '0.00';
    }
    return format.format(double.parse(this));
  }

  /// 银行卡格式
  String separate(
      {int count = 4, String separator = ' ', bool fromRightToLeft = false}) {
    if (isEmpty) {
      return '';
    }
    if (count < 1) {
      return this;
    }
    if (count >= length) {
      return this;
    }
    final String str = replaceAll(separator, '');
    final List<int> chars = str.runes.toList();
    final int namOfSeparation =
        (chars.length.toDouble() / count.toDouble()).ceil() - 1;
    final List<String> separatedChars = List.filled(
        chars.length + namOfSeparation.round(), '',
        growable: false);
    int j = 0;
    for (int i = 0; i < chars.length; i++) {
      separatedChars[j] = String.fromCharCode(chars[i]);
      if (i > 0 && (i + 1) < chars.length && (i + 1) % count == 0) {
        j += 1;
        separatedChars[j] = separator;
      }
      j += 1;
    }
    return fromRightToLeft
        ? String.fromCharCodes(separatedChars.join().runes.toList().reversed)
        : separatedChars.join();
  }

  /// 银行卡脱敏
  String get bankDesensy {
    if (isnull) {
      return '';
    }
    if (zhChar) {
      if (length > 10) {
        return '${substring(0, 7)}...';
      }
      return this;
    }
    if (length < 10) {
      return this;
    }
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < length - 8; i++) {
      buffer.write('*');
    }
    return substring(0, 4) + buffer.toString() + substring(length - 4, length);
  }

  /// 追加 阿里云oss参数
  String ossUrl({int w = 220, int h = 220, int q = 100}) {
    if (this == null || endsWith('.gif') || endsWith('.GIF')) {
      return this;
    }
    return '${this}?x-oss-process=image/resize,w_$w,h_$h/quality,q_$q';
  }

  /// 通过 (uri/url) 获取uri参数
  Map<String, dynamic> get uriParam {
    return Uri.parse(safety).queryParameters;
  }

  /// 通过 (uri/url) 获取host uri
  String get uriPath {
    String nUrl = '';
    final int paramsIndex = indexOf('?');
    nUrl = paramsIndex > -1 ? (substring(0, paramsIndex)) : this;
    return nUrl;
  }
}
