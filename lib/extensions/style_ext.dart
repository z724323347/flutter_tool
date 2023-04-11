import 'package:flutter/material.dart';

const String fontFamilyFzcthj = 'fzcthj';
const String fontFamilyAGENCYR = 'AGENCYR';
const String fontFamilyBdzy = 'bdzy';
const String fontFamilyDINCond = 'DINCond';

/// app 字体扩展
extension TextStyleExt on TextStyle {
  /// textstyle  使用方正字体
  TextStyle get copyFontFZ => copyWith(fontFamily: fontFamilyFzcthj);

  /// textstyle  使用bdzy字体
  TextStyle get copyFontBdzy => copyWith(fontFamily: fontFamilyBdzy);

  /// textstyle  使用DIN字体
  TextStyle get copyFontDin => copyWith(fontFamily: fontFamilyDINCond);

  /// textstyle  使用AGENCYR字体
  TextStyle get copyFontAgencyr => copyWith(fontFamily: fontFamilyAGENCYR);
}
