import 'dart:io';
import 'package:canknow_flutter_ui/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/session.dart';
import 'package:flutter_app/application/AppHelper.dart';
import 'package:canknow_flutter_ui/components/applicationBottomNavigationBar/ApplicationBottomNavigationBar.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:flutter_app/config/globalConfig.dart';
import 'package:flutter_app/config/menuConfig.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/store/chat.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/views/areas/friends/FriendPage.dart';
import 'package:flutter_app/views/areas/home/HomePage.dart';
import 'package:flutter_app/views/areas/message/MessageDialogPage.dart';
import 'package:flutter_app/views/areas/pictureLibrary/PictureLibraryPage.dart';
import 'package:flutter_app/views/areas/me/UserPage.dart';
import 'package:flutter_app/store/session.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_app/application/MessageManage.dart';
import '../store/friend.dart';

class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<HomePageState> homePageKey = new GlobalKey();
  final GlobalKey<MessageDialogPageState> messageDialogPageKey = new GlobalKey();
  final GlobalKey<FriendPageState> friendPageKey = new GlobalKey();
  final GlobalKey<UserPageState> userPageKey = new GlobalKey();

  var pages = [];
  int currentIndex = 0;

  /// 不退出
  Future<bool> _dialogExitApp(BuildContext context) async {
    ///如果是 android 回到桌面
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }

    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(key: homePageKey,),
      MessageDialogPage(key: messageDialogPageKey),
      PictureLibraryPage(),
      UserPage(key: userPageKey,)
    ];
    AppHelper.getVersion(context);

    if (AuthorizationService.isAuthorized) {
      Future.delayed(Duration.zero, () async {
        await this.getCurrentLoginInformation();
        if (GlobalConfig.enableChat) {
          await MessageManage().initialize(context);
          List<Friend> friends = await this.getFriends();
          await this.getMessages(friends);
        }
      });
    }
  }

  Future getCurrentLoginInformation() async {
    SessionStore sessionStore = Store.value<SessionStore>(context);
    if (sessionStore.user == null) {
      var result = await SessionApi.getCurrentLoginInformations();
      sessionStore.setUser(User.fromJson(result["user"]));
    }
  }

  Future getMessages(List<Friend> friends) async {
    Loading.show(context, message: '正在同步聊天消息', mask: true);
    try {
      ChatStore chatStore = Store.value<ChatStore>(context);
      await chatStore.getAllMessages(friends);
    }
    catch(e) {
      Toast.error(context, e.message);
    }
    finally {
      Loading.hide(context);
    }
  }

  Future<List<Friend>> getFriends() async {
    FriendStore friendStore = Store.value<FriendStore>(context);
    try {
      await friendStore.getFriends();
    }
    catch(e) {
      Toast.error(context, e.message);
    }
    return friendStore.friends;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return _dialogExitApp(context);
        },
      child: Scaffold(
        bottomNavigationBar: ApplicationBottomNavigationBar(
          items: MenuConfig.bottomMenus,
          showTitle: true,
          onTap: (index) {
            _changePage(index);
          },
        ),
        body: pages[currentIndex],
      ),
    );
  }

  void _changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}
