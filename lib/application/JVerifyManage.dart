import 'package:flutter/cupertino.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:flutter_app/store/index.dart';
import 'package:jverify/jverify.dart';
import 'package:flutter_app/store/jverify.dart';

class JVerifyManage {
  Jverify jverify;

  JVerifyManage._internal();

  static JVerifyManage _singleton = new JVerifyManage._internal();
  factory JVerifyManage() => _singleton;

  Future initialize(BuildContext context) async {
    JverifyStore jverifyStore = Store.value<JverifyStore>(context);

    jverify = new Jverify();
    jverify.setDebugMode(true);
    jverify.setup(appKey: AppConfig.jiguangAppId, channel: "developer-default");

    var result = await jverify.isInitSuccess();
    jverifyStore.setInitialized(result["result"]);

    if (result["result"]) {
      // 判断当前的手机网络环境是否可以使用认证。
      result = await jverify.checkVerifyEnable();
      jverifyStore.setUsable(result["result"]);
    }
  }

  Future<bool> preLogin (context) async {
    var result = await jverify.preLogin();
    var code = result["code"];
    JverifyStore jverifyStore = Store.value<JverifyStore>(context);
    jverifyStore.setPreLoginCode(code);
    return code == 7000;
  }
}