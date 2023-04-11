// ignore_for_file: avoid_redundant_argument_values, unnecessary_late

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

///logs 日志
void logs(Object? msg) {
  ///todo 不要上传
  // if (kReleaseMode) {
  //   // release模式不打印
  //   return;
  // }
  Chain chain = Chain.current(); // Chain.forTrace(StackTrace.current);
  // 将 core 和 flutter 包的堆栈合起来（即相关数据只剩其中一条）
  chain = chain
      .foldFrames((Frame frame) => frame.isCore || frame.package == 'flutter');
  // 取出所有信息帧
  final List<Frame> frames = chain.toTrace().frames;
  // 找到当前函数的信息帧
  final int idx =
      frames.indexWhere((Frame element) => element.member == 'logs');
  if (idx == -1 || idx + 1 >= frames.length) {
    return;
  }
  // 调用当前函数的函数信息帧
  final Frame frame = frames[idx + 1];

  // time
  final String d = DateTime.now().toString();
  String str = msg.toString();
  final String path = frame.uri.toString().split('/').last;
  final String? member = frame.member?.split('.').first;

  // log 长度切分
  while (str.isNotEmpty) {
    if (str.length > 512) {
      _defaultLog(
          '💙 $d $path(Line:${frame.line}) =>  ${str.substring(0, 512)}');
      str = str.substring(512, str.length);
    } else {
      _defaultLog('💙 $d $path(Line:${frame.line}) =>  $str');
      str = '';
    }
  }
  // final Completer<LogsEvent> completer = Completer<LogsEvent>()
  //   ..complete(
  //     LogsEvent(
  //       time: d,
  //       msg: msg.toString(),
  //       breakpoint: '$path(Line:${frame.line})',
  //       file: frame.uri.toString(),
  //     ),
  //   );
  // completer.future.then((v) => LogsEventSer.to.add(v));
}

void _defaultLog(String value, {bool isError = true}) {
  if (isError || kDebugMode) {
    dev.log(value, name: 'LOGS');
  }
}

///// ************************ LogU ************************ /////

late final LogU logU = LogU._internal();

class LogU {
  LogU._internal() {
    if (kDebugMode) {
      Logger.level = Level.debug;
    } else if (kProfileMode) {
      Logger.level = Level.error;
    } else {
      Logger.level = Level.nothing;
    }
  }

  final Logger _logger = Logger(
    filter: DevelopmentFilter(),
    printer: () {
      final PrettyPrinter realPrinter = PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 10,
        // width of the output
        lineLength: stdout.hasTerminal ? stdout.terminalColumns : 120,
        colors: !Platform.isIOS,
        printEmojis: true,
        printTime: true,
      );

      if (!realPrinter.colors) {
        return PrefixPrinter(realPrinter);
      }

      return realPrinter;
    }(),
    level: Level.verbose,
  );

  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }

  dynamic onError<T>(dynamic error, StackTrace stackTrace) {
    e('', error, stackTrace);
  }
}
