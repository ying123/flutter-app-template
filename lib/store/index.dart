import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/CommonUtil.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/store/chat.dart';
import 'package:flutter_app/store/friend.dart';
import 'package:flutter_app/store/jverify.dart';
import 'package:flutter_app/store/localization.dart';
import 'package:flutter_app/store/authorization.dart';
import 'package:flutter_app/store/session.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart' show Consumer, Provider, MultiProvider, ChangeNotifierProvider;

class Store {
  static initialize(child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_)=>AppStore(CommonUtil.getThemeData(Variables.primaryColor)),),
        ChangeNotifierProvider(builder: (_)=>LocalizationStore(),),
        ChangeNotifierProvider(builder: (_)=>SessionStore(),),
        ChangeNotifierProvider(builder: (_)=>AuthorizationStore(),),
        ChangeNotifierProvider(builder: (_)=>JverifyStore(),),
        ChangeNotifierProvider(builder: (_)=>ChatStore(),),
        ChangeNotifierProvider(builder: (_)=>FriendStore(),)
      ],
      child: child,
    );
  }

  static T value<T>(context) {
    return Provider.of<T>(context);
  }

  static Consumer connect<T>({ builder, child}) {
    return Consumer<T>(builder: builder, child: child,);
  }
}