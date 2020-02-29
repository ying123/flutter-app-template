import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application//Application.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:flutter_app/env/EnvConfig.dart';
import 'package:flutter_app/env/configWrapper.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/views/App.dart';
import 'package:flutter_app/views/common/ErrorPage.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'dart:async';
import 'env/dev.dart';

void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
}

void collectLog(String line) {
  //收集日志
}

void body() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
    return ErrorPage(details.exception.toString() + "\n " + details.stack.toString(), details);
  };
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    runApp(ConfigWrapper(
      config: EnvConfig.fromJson(config),
      child: Store.initialize(App()),
    ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await Application.initialize();

  // 初始化微信插件
  await fluwx.registerWxApi(
      appId: AppConfig.weixinAppId,
      doOnAndroid: true,
      doOnIOS: true);

  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };
  runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          collectLog(line);
        },
      ),
      onError: (Object obj, StackTrace stack) {
        print(obj);
        print(stack);
      });
}