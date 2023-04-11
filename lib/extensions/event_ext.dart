import 'dart:async';

import 'package:event_bus/event_bus.dart';

/// event_bus 扩展函数 EventBusUtil
extension AppEventBus on EventBus {
  /// 监听
  StreamSubscription<T> listen<T>(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return on<T>().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 发送事件
  void send<T>(T event) {
    fire(event);
  }
}

class EventBusUtil {
  static EventBus? bus;

  static EventBus getInstance() {
    bus ??= EventBus();
    return bus!;
  }

  /// 创建
  static List<StreamSubscription<dynamic>> create() {
    return <StreamSubscription<dynamic>>[];
  }

  /// 关闭
  static void close(List<StreamSubscription<dynamic>> stream) {
    // destroy();
    for (final sub in stream) {
      sub.cancel();
    }
  }
}

/// 测试 eventBus
///
/// 流程
///
/// 1.初始化  final _stream = EventBusUtil.create();
///
/// 2.init添加监听  _stream.addAll([kTestBus.listen])  todo:同时 kTestBus.send(data)
///
/// 3.dispose关闭 EventBusUtil.close(_stream);
///
final kTestBus = EventBus();

/// 支付后更新订单列表
final kRefreshBus = EventBus(); //.customController(StreamController());

/// 取消/支付 后更新订单列表
final kRefreshOrderBus = EventBus(); //.customController(StreamController());

/// 创建Pkg更新Pkg列表
final kRefreshPkgCreate = EventBus(); //.customController(StreamController());

/// 柜子数据刷新 (数量 + 盲盒)
final kRefreshCabintBus = EventBus();

/// 项目详情打开侧拉
final kProjShowDrawerBus = EventBus();

class EventBusData {
  ///  类型
  int type;

  /// 数据
  dynamic data;

  /// 额外msg
  Map<String, dynamic>? ext;

  EventBusData({required this.type, this.data, this.ext});
}
