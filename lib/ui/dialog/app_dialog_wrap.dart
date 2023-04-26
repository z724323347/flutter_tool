import 'package:flutter/material.dart';

/// 弹窗盒子
class AppDialogWrap extends StatelessWidget {
  const AppDialogWrap({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [child],
      ),
    );
  }
}
