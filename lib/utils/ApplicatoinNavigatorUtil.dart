import 'package:flutter/cupertino.dart';
import 'package:canknow_flutter_ui/page/PictureViewPage.dart';
import 'package:flutter_app/application/Application.dart';

class ApplicationNavigatorUtil {
  static Future<dynamic> push(Widget widget) {
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => widget,
      settings: new RouteSettings(
        name: widget.toStringShort(),
        isInitialRoute: false,
      ),
    );
    return Application.navigatorKey.currentState.push(route);
  }

  static Future<dynamic> pushReplacement(Widget widget) {
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => widget,
      settings: new RouteSettings(
        name: widget.toStringShort(),
        isInitialRoute: false,
      ),
    );
    return Application.navigatorKey.currentState.pushReplacement(route);
  }

  static Future<dynamic> pushAndRemoveUntil(Widget widget) {
    final route = new CupertinoPageRoute(
      builder: (BuildContext context) => widget,
      settings: new RouteSettings(
        name: widget.toStringShort(),
        isInitialRoute: false,
      ),
    );
    return Application.navigatorKey.currentState.pushAndRemoveUntil(route, (route) => route == null);
  }

  static popToRootPage() {
    Application.navigatorKey.currentState.popUntil(ModalRoute.withName('/'));
  }

  static landing() {
    Application.navigatorKey.currentState.pushNamedAndRemoveUntil('/index', (Route<dynamic> route) => false);
  }

  static gotoPictureViewPage(BuildContext context, String url) async {
    await Navigator.pushNamed(context, PictureViewPage.sName, arguments: url);
  }
}