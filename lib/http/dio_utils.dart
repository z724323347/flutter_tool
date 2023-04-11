// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/app_util.dart';
import '../utils/log_util.dart';
import 'interceptor/cookie_storage.dart';
import 'interceptor/logger_interceptor.dart';

class DioUtils {
  static late final String dir;

  static late Uri baseUri;
  static late Dio dio;

  static DefaultCookieJar get _cookieJar => appCookieJar;

  ///  设置环境参数
  static Future<void> initEnvParams() async {
    dir = (await getApplicationDocumentsDirectory()).path;
    logU.v('AppDoc dir: $dir');
  }

  static void updateUri(Uri uri) {
    logs('''
    App Uri: $uri
    App Uri.baseUrl: ${uri.origin}
    ''');

    baseUri = uri;
    dio = _createDio();
  }

  static Future<String?> spCookie(String cookieName) {
    return _cookieJar.loadForRequest(baseUri).then((value) {
      if (value == null || value.isEmpty) {
        return null;
      }
      Cookie? cookie;
      for (final Cookie element in value) {
        if (element.name == cookieName) {
          cookie = element;
        }
      }
      if (cookie == null) {
        return null;
      }
      return cookie.value;
    });
  }

  static Cookie? getCookie(
    String cookieName, {
    bool ignoreExpired = true,
  }) {
    final cookies = getCookies(ignoreExpired: ignoreExpired);
    logs('cookies--- $cookieName');
    logs('cookies--- $cookies');
    return cookies[cookieName];
  }

  static Map<String, Cookie> getCookies({
    bool ignoreExpired = true,
  }) {
    final hostCookies = _cookieJar.hostCookies;
    final pathCookies = hostCookies[baseUri.host]?['/'];

    if (pathCookies == null || pathCookies.isEmpty) {
      return {};
    }

    final cookies = Map.of(pathCookies);
    if (ignoreExpired) {
      cookies.removeWhere((key, value) => value.isExpired());
    }

    return cookies.map((key, value) => MapEntry(key, value.cookie));
  }

  static bool setCookie(
    String name,
    String value, {
    Duration? expire,
    String? path,
  }) {
    try {
      expire ??= const Duration(days: 1);
      path ??= '/';

      final cookie = Cookie(name, value)
        ..expires = DateTime.now().add(expire)
        ..path = path;
      _cookieJar.saveFromResponse(baseUri, [cookie]);
    } catch (error, stackTrace) {
      logU.e('', error, stackTrace);
      return false;
    }

    return true;
  }

  static Future<void> clearCookies() {
    return _cookieJar.deleteAll();
  }

  static Future<Uint8List> requestImage(String url) async {
    final Options options = Options(
      headers: {'Content-Type': 'image/png'},
      responseType: ResponseType.bytes,
    );

    final Response<dynamic> response = await dio.get(url, options: options);
    try {
      return Uint8List.fromList(response.data);
    } catch (error, stack) {
      logs('requestImage $error  $stack');
      rethrow;
    }
  }

  static Dio _createDio() {
    final Dio dio = Dio(
      BaseOptions(
        //请求基地址,可以包含子路径
        baseUrl: baseUri.origin,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: 30000,
        //响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: 30000,
        //Http请求头.
        headers: {'appVersion': AppUtil.packageInfo.version},
        //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
        contentType: Headers.jsonContentType,
        //表示期望以那种格式(方式)接受响应数据。接受三种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
        responseType: ResponseType.plain,
        followRedirects: false,
      ),
    );
    // ignore: cascade_invocations
    dio.transformer = _FlutterTransformer();
    // ..httpClientAdapter = HttpAdapter();
    dio.interceptors
      // ..add(DebugLogInterceptor())
      // ..add(DataInterceptor())
      // ..add(AppCookieManager(_cookieJar))
      // ..add(TimeInterceptor())
      ..add(LoggerInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (Object object) {
          const int limit = 920;
          void logPrint(message) {
            if (!Platform.isIOS) {
              print('\x1B[34mDio │ $message\x1B[0m');
            } else {
              print('Dio │ $message');
            }
          }

          final String message = object.toString();
          if (message.length <= limit) {
            logPrint(message);
            return;
          }

          final Runes runes = message.runes;
          for (int i = 0; i < runes.length;) {
            final int start = i;
            i = math.min(i + limit, runes.length);
            final String subMessage = message.substring(start, i);
            logPrint(subMessage);
          }
        },
      ));
    }
    logs(dio.options.baseUrl);
    return dio;
  }
}

/// dio  cancelToken
class CancelTokenSet {
  final Set<CancelToken> _tokenSet = <CancelToken>{};

  CancelToken get produce {
    final CancelToken token = CancelToken();
    _tokenSet.add(token);
    return token;
  }

  void cancelAll([dynamic reason]) {
    for (final CancelToken token in _tokenSet) {
      token.cancel(reason);
    }
    _tokenSet.clear();
  }
}

/// http 数据后台线程解析
class _FlutterTransformer extends DefaultTransformer {
  _FlutterTransformer() : super(jsonDecodeCallback: _parseJson);
}

dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future<dynamic> _parseJson(String text) {
  return compute(_parseAndDecode, text);
}
