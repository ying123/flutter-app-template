import 'package:flutter/widgets.dart';
import 'package:flutter_app/views/areas/about/aboutPage.dart';
import 'package:flutter_app/views/areas/chat/ChatPage.dart';
import 'package:flutter_app/views/areas/friends/AddFriendPage.dart';
import 'package:flutter_app/views/areas/friends/FriendPage.dart';
import 'package:flutter_app/views/areas/friends/FriendSearchPage.dart';
import 'package:flutter_app/views/areas/home/SearchPage.dart';
import 'package:flutter_app/views/areas/languages/languages.dart';
import 'package:flutter_app/views/areas/map/MapPage.dart';
import 'package:flutter_app/views/areas/settings/SettingPage.dart';
import 'package:flutter_app/views/areas/settings/ThemePage.dart';
import 'package:flutter_app/views/areas/me/ProfilePage.dart';
import 'package:flutter_app/views/areas/me/Qrcode.dart';
import 'package:flutter_app/views/areas/me/UserPage.dart';
import 'package:flutter_app/views/authorize/login/Login.dart';
import 'package:canknow_flutter_ui/page/PictureViewPage.dart';
import 'package:flutter_app/views/authorize/login/AccountLogin.dart';
import 'package:flutter_app/views/common/FeedbackPage.dart';
import 'package:flutter_app/views/common/HelpPage.dart';
import 'package:flutter_app/views/Index.dart';
import 'package:flutter_app/views/Splash.dart';
import 'package:flutter_app/views/areas/friends/FriendRequest.dart';
import 'package:flutter_app/views/authorize/Captcha.dart';
import 'package:flutter_app/views/areas/user/UserProfile.dart';

Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => new Splash(),
  '/home/search': (BuildContext context) => new SearchPage(),
  '/common/feedback': (BuildContext context) => new FeedbackPage(),
  '/common/help': (BuildContext context) => new HelpPage(),
  '/login': (BuildContext context) => new Login(),
  '/loginByUserName': (BuildContext context) => new AccountLogin(),
  '/capcha': (BuildContext context) => new Captcha(),
  '/index': (BuildContext context) => new Index(),
  '/user': (BuildContext context) => new UserPage(),
  '/user/myProfile': (BuildContext context) => new ProfilePage(),
  '/user/profile': (BuildContext context) => new UserProfile(),
  '/user/qrcode': (BuildContext context) => new Qrcode(),
  '/languages': (BuildContext context) => new LanguagesPage(),
  '/settings': (BuildContext context) => new SettingPage(),
  '/settings/theme': (BuildContext context) => new ThemePage(),
  '/about': (BuildContext context) => new AboutPage(),
  '/friend': (BuildContext context) => new FriendPage(),
  '/friend/add': (BuildContext context) => new AddFriendPage(),
  '/friend/friendRequest': (BuildContext context) => new FriendRequest(),
  '/friend/search': (BuildContext context) => new FriendSearchPage(),
  '/chat': (BuildContext context) => new ChatPage(),
  '/map': (BuildContext context) => new MapPage(),
  PictureViewPage.sName: (context) {
    return PictureViewPage();
  },
};