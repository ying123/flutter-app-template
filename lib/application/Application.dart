import 'package:canknow_flutter_ui/utils/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:canknow_flutter_ui/utils/LocalStorage.dart';
import 'package:package_info/package_info.dart';

class Application {
  static String version = '0.0.1';
  static GlobalKey<NavigatorState> navigatorKey = Global.navigatorKey;

  static Future initialize() async {
    await LocalStorage.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }
}