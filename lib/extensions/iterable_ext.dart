import 'dart:convert';

import 'package:collection/collection.dart';

/// Iterable/List 等 扩展函数
///
extension IterableExt<T> on Iterable<T> {
  List<T> divide(
    T divider, {
    bool addBefore = false,
    bool addAfter = false,
  }) {
    final list = <T>[];
    forEachIndexed((index, child) {
      if (addBefore || index > 0) {
        list.add(divider);
      }
      list.add(child);
    });
    if (addAfter) {
      list.add(divider);
    }

    return list;
  }
}

// 给 数组类型添加扩展方法
extension ListExt<T> on List<T> {
  Function get forEachIndex {
    return asMap().keys.toList().forEach;
  }

  Function get valueKeyMap {
    return asMap().entries.map;
  }

  Function get mapIndex {
    return asMap().keys.map;
  }

  Function get exchangeModel {
    return forEach;
  }

  List<T> removeNull() {
    removeWhere((element) => element == null);
    return this;
  }

  /// 截取列表 最大长度
  List<T> max([int max = 3]) {
    if (length <= max) {
      return this;
    } else {
      return sublist(0, max);
    }
  }

  /// 获取第一个元素
  String? get fValue {
    if (this != null && isNotEmpty) {
      return jsonEncode(first);
    }
    return null;
  }
}

extension ListViewExt<Widget> on List<Widget> {
  /// listview  追加尾部
  Iterable<Widget> addFoot({required Widget child}) {
    return this..add(child);
  }

  /// listview  插入头部
  Iterable<Widget> addHead({required Widget child}) {
    return [child, ...this];
  }
}

extension MapExt on Map<String, dynamic> {
  Map<String, dynamic> add({String? k, dynamic v}) {
    if (k != null || k!.isNotEmpty) {
      this[k] = v;
    }
    return this;
  }

  /// 移除多少项
  Map<String, dynamic> rmLength({int count = 10}) {
    if (length > count) {
      for (var i = 0; i < count; i++) {
        remove(keys.last);
      }
    }
    return this;
  }
}
