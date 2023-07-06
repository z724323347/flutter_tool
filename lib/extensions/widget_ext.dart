import 'package:flutter/widgets.dart';

/// add Padding Property to widget
extension WidgetPaddingExt on Widget {
  Widget pAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget pOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get pZero => Padding(padding: EdgeInsets.zero, child: this);
}

/// Add margin property to widget
extension WidgetMarginExt on Widget {
  Widget mAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget mOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get mZero => Container(margin: EdgeInsets.zero, child: this);
}

/// Allows you to insert widgets inside a CustomScrollView
extension WidgetSliverBoxExt on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
