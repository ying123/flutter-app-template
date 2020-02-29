import 'dart:io';
import 'package:flutter_app/routes/ApplicationNavigatorObserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application/Application.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizationsDelegate.dart';
import 'package:canknow_flutter_ui/locale/localeUtil.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/store/localization.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/views/common/NotFoundPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationStore = Store.value<LocalizationStore>(context);
    var appStore = Store.value<AppStore>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
        navigatorKey: Application.navigatorKey,
        onGenerateTitle: (context){
          return 'Canknow';
        },
        onUnknownRoute: (RouteSettings routeSettings) => new MaterialPageRoute(
            builder: (context) => NotFoundPage(
              title: 'comming soon',
              message: "Under Development",
            )
        ),
        // 当通过Navigation.of(context).pushNamed跳转路由时，在routes查找不到时，会调用该方法
        onGenerateRoute: (value) {
          RoutePageBuilder builder = (BuildContext nContext, Animation<double> animation, Animation<double> secondaryAnimation) => Center(
              child: Container()
          );
          return PageRouteBuilder(
            pageBuilder: builder,
            // transitionDuration: const Duration(milliseconds: 0),
          );
        },
        navigatorObservers: [ApplicationNavigatorObserver()],
        title: 'Flutter Demo',
        localizationsDelegates: [
          const ApplicationLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: localeUtil.supportedLocales(),
        locale: localizationStore.currentLanguageModel?.locale,
        theme: appStore.themeData,
        initialRoute: '/',
        routes: routes
    );
  }
}