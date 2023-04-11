import 'package:decimal/decimal.dart';

final k2D = Decimal.fromInt(2);
final k5D = Decimal.fromInt(5);
final k10D = Decimal.fromInt(10);
final k100D = Decimal.fromInt(100);

extension DecimalExt on Decimal {
  // 百分比
  String toPercent([int? fractionDigits]) {
    final decimal = this * k100D;
    final text = fractionDigits != null
        ? decimal.setScale(digits: fractionDigits, doRemove: true).toString()
        : decimal.toString();
    return '$text%';
  }

  /// 输出String
  String stringAs({int? digits, bool doRemove = false}) {
    if (digits == null) {
      return toString();
    }
    return setScale(digits: digits, doRemove: doRemove).toString();
  }

  /// 设置小数位数
  /// [fractionDigits] 保留的小数位
  /// [doRemove] true 截取，false 四舍五入
  Decimal setScale({int digits = 2, bool doRemove = false}) {
    if (scale <= digits) {
      return this;
    }
    if (doRemove) {
      return floor(scale: digits);
    } else {
      return round(scale: digits);
    }
  }
}
