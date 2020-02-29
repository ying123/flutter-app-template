import 'dart:math';

import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/store/chat.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class ApplicationUtil {
  static String getFilePath(String path) {
    return TextUtil.isEmpty(path) ? null : AppConfig.baseUrl + path;
  }

  static List<Color> getThemeListColor() {
    return [
      Variables.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static pushTheme(AppStore store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = getThemeData(colors[index]);
    store.setTheme(themeData);
  }

  static getThemeData(Color color) {
    return ThemeData(primarySwatch: color, platform: TargetPlatform.android);
  }

  //  同步更新启动icon消息提醒
  void updateBadger(BuildContext rootContext) {
    ChatStore chatStore = Store.value<ChatStore>(rootContext);
    int unreadCount = chatStore.messageDialogs.fold(0, (value, messageDialog) {
      return value + messageDialog.unreadCount;
    });
    if (unreadCount == 0) {
      FlutterAppBadger.removeBadge();
    }
    else {
      FlutterAppBadger.updateBadgeCount(min(unreadCount, 99));
    }
  }
}