import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import '../dio_utils.dart';

/// app cookie 拦截器
class AppCookieManager extends Interceptor {
  AppCookieManager(this.cookieJar);

  final CookieJar cookieJar;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    getCookies(options).then((String cookie) {
      if (cookie.isNotEmpty) {
        options.headers[HttpHeaders.cookieHeader] = cookie;
      }
      handler.next(options);
    }).catchError((dynamic error, StackTrace stackTrace) {
      final DioError retErr = DioError(requestOptions: options, error: error)
        ..stackTrace = stackTrace;
      handler.reject(retErr, true);
    });
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    saveCookies(response)
        .then((_) => handler.next(response))
        .catchError((dynamic error, StackTrace stackTrace) {
      final DioError retErr = DioError(
        requestOptions: response.requestOptions,
        error: error,
      )..stackTrace = stackTrace;
      handler.reject(retErr, true);
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      saveCookies(err.response!)
          .then((_) => handler.next(err))
          .catchError((dynamic error, StackTrace stackTrace) {
        final DioError retErr = DioError(
          requestOptions: err.response!.requestOptions,
          error: error,
        )..stackTrace = stackTrace;
        handler.next(retErr);
      });
    } else {
      handler.next(err);
    }
  }

  Future<void> saveCookies(Response<dynamic> response) async {
    final List<String>? cookies = response.headers[HttpHeaders.setCookieHeader];

    if (cookies != null) {
      await cookieJar.saveFromResponse(
        response.requestOptions.cookieUri,
        cookies.map((String str) => Cookie.fromSetCookieValue(str)).toList(),
      );
      // await DioUtils.spCookie('CookieKey').then((value) {
      //   if (value != null) {}
      // });
    }
  }

  Future<String> getCookies(RequestOptions options) {
    return cookieJar
        .loadForRequest(options.cookieUri)
        .then((List<Cookie> cookies) {
      // cookies
      //   ..removeWhere((Cookie cookie) => cookie.name == CookieKey.APP_LANGUAGE)
      //   ..add(Cookie(CookieKey.APP_LANGUAGE, AppSetting.to.localeCookieValue));
      return cookies
          .map((Cookie cookie) => '${cookie.name}=${cookie.value}')
          .join('; ');
    });
  }
}

extension _RequestOptionsExt on RequestOptions {
  Uri get cookieUri {
    return Uri.parse(DioUtils.dio.options.baseUrl);
  }
}
