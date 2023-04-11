import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'auto_size_util.dart';

void runAutoApp(Widget app) {
  AutoWidgetsFlutterBinding.ensureInitialized()
    // ignore: invalid_use_of_protected_member
    ..scheduleAttachRootWidget(app)
    ..scheduleWarmUpFrame();
}

/// 一个自定义的 WidgetsFlutterBinding 子类
///
///   part1
///
/// ```dart
///   void main() {
///      runMyApp(const MyApp());
///   }
/// ```
///   part2
///
/// ```dart
///   void runMyApp(Widget app) {
///     AutoWidgetsFlutterBinding.ensureInitialized()
///       ..scheduleAttachRootWidget(app)
///       ..scheduleWarmUpFrame();
///   }
/// ```
class AutoWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      AutoWidgetsFlutterBinding();
    }
    return WidgetsBinding.instance!;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    return ViewConfiguration(
      size: AutoSizeUtil.getSize(),
      devicePixelRatio: AutoSizeUtil.getDevicePixelRatio(),
    );
  }

  /// 因为修改了 devicePixelRatio ，得适配点击事件  GestureBinding
  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(PointerDataPacket packet) {
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data,
        // 适配事件的转换比率,采用修改的
        AutoSizeUtil.getDevicePixelRatio()));
    if (!locked) {
      _flushPointerEventQueue();
    }
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked) {
      scheduleMicrotask(_flushPointerEventQueue);
      _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
    }
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult result;
    if (event is PointerDownEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
      assert(() {
        if (debugPrintHitTestResults) debugPrint('$event: $result');
        return true;
      }());
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer)!;
    } else if (event.down) {
      result = _hitTests[event.pointer]!;
    } else {
      return; // We currently ignore add, remove, and hover move events.
    }
    if (result != null) {
      dispatchEvent(event, result);
    }
  }
}
