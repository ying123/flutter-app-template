import 'dart:io';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter_app/application/Application.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:flutter_app/views/components/updateDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/system.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/models/CheckUpdateResult.dart';

class AppHelper {
  static String removeDot(value) {
    return value.toString().replaceAll('.', '');
  }

  static NavigatorState getNavigator() {
    return Application.navigatorKey.currentState;
  }

  static isLatest(netVersionValue) {
    int currentVersion = int.parse(removeDot(Application.version));
    int netVersion = int.parse(removeDot(netVersionValue));
    return currentVersion >= netVersion;
  }

  static getVersion (context) async {
    if (Platform.isIOS)
      return;
    var appStore = Store.value<AppStore>(context);
    var result = await SystemApi.checkUpdate();
    var netVersion = result["appVersion"];
    appStore.setNetVersion(netVersion);
  }

  static Future<CheckUpdateResult> checkUpdate(context, { showMessage = false }) async {
    try {
      var result = await SystemApi.checkUpdate();
      var appStore = Store.value<AppStore>(context);
      appStore.setNetVersion(result["appVersion"]);
      if (isLatest(result["appVersion"])) {
        appStore.setIsLatest(true);
        if (showMessage) {
          Toast.show(context, ApplicationLocalizations.of(context).text('update.currentIsLatest'));
        }
        return null;
      }
      return CheckUpdateResult.fromJson(result);
    }
    catch(e) {
      Toast.show(context, e.message);
    }
  }
}