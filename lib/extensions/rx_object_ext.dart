import 'dart:async';

import 'package:get/get.dart';

/// GetX object ext
extension RxObjectT<T> on T {
  ///  等效  RxString text = ''.obs
  RxObject<T> get obsj => RxObject<T>(this);
}

/// GetX object ext
class RxObject<T> extends Rx<T> with RxTMixin<T> {
  RxObject(T initial) : super(initial);
}

mixin RxTMixin<T> on RxObjectMixin<T> {
  Completer<T>? _completer;
  dynamic error;

  bool get isCompleted => !isWaiting;
  bool get isWaiting {
    value;
    return _completer?.isCompleted == false;
  }

  bool get hasData => value != null;
  bool get hasError {
    value;
    return error != null;
  }

  Future<T> sLoad(Future<T> Function() fn) async {
    var completer = _completer;
    if (completer == null || completer.isCompleted) {
      completer = _completer = Completer();
      Future.delayed(Duration.zero, refresh);

      try {
        value = await fn();
        error = null;
        completer.complete(value);
      } catch (error, stackTrace) {
        this.error = error;
        completer.completeError(error, stackTrace);
        refresh();
      }
    }
    return completer.future;
  }
}
