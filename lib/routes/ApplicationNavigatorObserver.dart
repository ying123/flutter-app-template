import 'package:flutter/cupertino.dart';

class ApplicationNavigatorObserver extends NavigatorObserver{
  @override
  void didReplace({ Route<dynamic> newRoute, Route<dynamic> oldRoute }) {
    super.didReplace(newRoute:newRoute, oldRoute: oldRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    // 当调用Navigator.push时回调
    super.didPush(route, previousRoute);
    //可通过route.settings获取路由相关内容
    //route.currentResult获取返回内容
    //....等等
    print(route.settings.name);
  }
}