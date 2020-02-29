import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_app/application/AppHelper.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:package_info/package_info.dart';

class Fetch {
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = new CancelToken();
  final baseUrl;
  final parseResult;

  Fetch({ this.baseUrl, this.parseResult = false }) {
    String _platform = 'android';
    String _version = PackageInfo().version;
    var options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Fetch.CONNECT_TIMEOUT,
      receiveTimeout: Fetch.RECEIVE_TIMEOUT,
      headers: {
        'platform': _platform,
        'version': _version,
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.json.value,
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    var cookieJar = CookieJar();
    dio = new Dio(options);
    dio.interceptors.add(CookieManager(cookieJar));
    addInterceptor();
  }

  addInterceptor(){
    dio.interceptors.add(InterceptorsWrapper(
        onRequest:(RequestOptions options){
          options.headers["Abp.TenantId"] = 1;
          options.headers["Authorization"] = "Bearer ${AuthorizationService.getToken()}";
        },
        onResponse:(Response response) {
          if (this.parseResult) {
              return response.data;
          }
          else {
            return response;
          }
        },
        onError: (DioError e) {
          if (CancelToken.isCancel(e)) {
            print('get请求取消! ' + e.message);
          }
          else {
            if (e.response != null) {
              if (e.response.statusCode == 401) {
                AuthorizationService.logout();
                AppHelper.getNavigator().pushReplacementNamed("/login");
              }
              if (this.parseResult) {
                return e.response.data['error']['details'] ?? e.response.data['error']['message'];
              }
            }
            else {
              return e;
            }
          }
          return e;
        }
    ));
  }

  formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    }
    else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    }
    else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    }
    else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    }
    else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    }
    else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  get(url, {queryParameters, options, cancelToken}) async {
    Response response = await dio.get(
      url,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return parseResponse(response);
  }

  post(url, {data, options, cancelToken}) async {
    Response response = await dio.post(
      url,
      data: data,
      cancelToken: cancelToken,
    );
    return parseResponse(response);
  }

  put(url, {data, options, cancelToken}) async {
    Response response = await dio.put(
      url,
      data: data,
      cancelToken: cancelToken,
    );
    return parseResponse(response);
  }

  parseResponse(Response response) {
    return this.parseResult ? response.data["result"] : response.data;
  }

  download(urlPath, savePath) async {
    Response response;
    response = await dio.download(urlPath, savePath, onReceiveProgress: (int count, int total){

    });
    return response.data;
  }

  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}