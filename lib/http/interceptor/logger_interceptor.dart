import 'dart:convert';
import 'dart:io';

import 'package:app_tool/utils/log_util.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

///
/// 记录拦截器
///
/// example：
///   设置打印Cookie, true：打印，false: 不打印
///   LoggerInterceptor.isPrintCookie = true;
///
class LoggerInterceptor extends Interceptor {
  factory LoggerInterceptor() {
    bool isProductEnv = true;
    assert((() {
      isProductEnv = false;
      return true;
    })());
    return _instance ??= LoggerInterceptor._(isProductEnv);
  }

  LoggerInterceptor._(this._isProductEnv);

  static LoggerInterceptor? _instance;

  /// 是否生产环境
  final bool _isProductEnv;

  /// 是否打印请求
  static bool isPrintRequest = false;

  /// 是否打印请求头
  static bool isPrintRequestHeader = false;

  /// 是否打印请求参数
  static bool isPrintRequestParam = false;

  /// 是否打印响应数据
  static bool isPrintResponse = false;

  /// 是否打印Cookie
  static bool isPrintCookie = false;

  static final DateFormat format = DateFormat('HH:mm:ss.SSS');

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (!_isProductEnv) {
      final String time = format.format(DateTime.now());
      if (isPrintRequest) {
        logs('$time [ Network ] Request: ${options.uri}');
      }
      if (isPrintRequestHeader) {
        logs('$time [ Network ] Request Headers: ${options.headers}');
      }
      if (isPrintRequestParam) {
        logs(
            '$time [ Network ] Request queryParameters: ${options.queryParameters}');

        final dynamic data = options.data;
        if (data is FormData) {
          logs('$time [ Network ] Request formData: ${data.fields}');
        }
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!_isProductEnv) {
      final String time = format.format(DateTime.now());
      if (isPrintResponse) {
        logs(
            // ignore: avoid_dynamic_calls
            '$time API: (${response.requestOptions.uri}) \n[ Network ] Response: ${jsonEncode(response.data)}, ${response.data.runtimeType}');
      }
      if (isPrintCookie) {
        logs(
            '$time [ Network ] set-Cookies: ${response.headers[HttpHeaders.setCookieHeader]}');
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    List<MapEntry<String, String>>? postInfo;
    final dynamic requestData = err.requestOptions.data;
    if (requestData is FormData) {
      postInfo = requestData.fields;
    }

    logs('[Network] Request Error: $err');
    logs(
        '[Network] Error Url: ${err.requestOptions.uri} header: ${err.requestOptions.headers} 参数: ${err.requestOptions.data} $postInfo');
    logs(
        '[Network] Error Msg: ${err.response?.data} 状态码: ${err.response?.statusCode}');

    super.onError(err, handler);
  }
}
