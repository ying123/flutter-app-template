import 'package:canknow_flutter_ui/components/OnlineStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/AppHelper.dart';

class AppStore with ChangeNotifier{
  String netVersion = '0.0.1';
  bool isLatest = true;
  ThemeData themeData;
  OnlineStatusEnum onlineStatus = OnlineStatusEnum.Offline;

  AppStore(this.themeData);

  void setTheme(ThemeData themeData) {
    this.themeData = themeData;
    notifyListeners();
  }

  void setNetVersion(netVersion) {
    if (netVersion == this.netVersion) {
      return;
    }
    this.netVersion = netVersion;
    setIsLatest(AppHelper.isLatest(this.netVersion));
    notifyListeners();
  }

  void setIsLatest(isLatest) {
    this.isLatest = isLatest;
  }

  setOnlineStatus(OnlineStatusEnum onlineStatus) {
    this.onlineStatus = onlineStatus;
    notifyListeners();
  }
}
