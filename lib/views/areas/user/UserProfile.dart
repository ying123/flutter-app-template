import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/actionSheet/MenuActionSheet.dart';
import 'package:canknow_flutter_ui/components/actionSheet/MenuActionSheetItem.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/friend.dart';
import 'package:flutter_app/apis/user.dart';
import 'package:flutter_app/models/CommonUser.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:flutter_app/views/areas/chat/ChatPage.dart';
import '../../../store/friend.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/store/session.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int userId;
  CommonUser user;
  Friend newFriend;
  Friend friend;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.initialize();
    });
  }

  initialize() async {
    userId = ModalRoute.of(context).settings.arguments;
    await this.getUser();
  }

  getUser() async {
    var result = await UserApi.get({
      "id": this.userId
    });
    setState(() {
      user = CommonUser.fromJson(result);
    });
  }

  _showMenu(BuildContext context){
    MenuActionSheet.show(context, [
      MenuActionSheetItem(title: ApplicationLocalizations.of(context).text('setRemark'), handle: () {
;
      }),
      MenuActionSheetItem(title: ApplicationLocalizations.of(context).text('block'), handle: () {

      }),
    ]);
  }

  buildHeader() {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Variables.contentPadding),
      decoration: BoxDecoration(color: themeData.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(Variables.contentPadding),
            child: GestureDetector(
              onTap: () {

              },
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: ApplicationUtil.getFilePath(user.avatar),
                  fit: BoxFit.cover,
                  width: Variables.componentSizeLargest,
                  height: Variables.componentSizeLargest,
                  errorWidget: (context, url, error) => Image.asset('assets/images/avatar.png',
                    width: Variables.componentSizeLargest,
                    height: Variables.componentSizeLargest,),
                ),
              ),
            ),
          ),
          Container(
            child: Text(user?.nickName??user?.userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: Variables.fontSize)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SessionStore sessionStore = Store.value<SessionStore>(context);
    FriendStore friendStore = Store.value<FriendStore>(context);
    newFriend = friendStore.getNewFriendByUserId(userId);
    friend = friendStore.getFriendByUserId(userId);

    return Scaffold(
      appBar: ApplicationAppBar(
        borderColor: Colors.transparent,
        brightness: Brightness.dark,
        actions: <Widget>[
          ApplicationIconButton(icon: ApplicationIcon('menu-dot', size: Variables.componentSizeSmall), ghost: true, onTap: () {
            this._showMenu(context);
          },)
        ],
      ),
      body: user != null ? Container(
        child: ListView(
          children: <Widget>[
            if (user != null) buildHeader(),
            Spaces.vComponentSpan,
            if(friend != null) TextButton(text: ApplicationLocalizations.of(context).text('chat'), scene: Scene.white, onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                return new ChatPage(friend: friend);
              }));
            },),
            if(friend != null) TextButton(text: ApplicationLocalizations.of(context).text('voiceOrVideoChat'), scene: Scene.white, onTap: () {

            },),
            if(newFriend != null) TextButton(text: ApplicationLocalizations.of(context).text('passFriendRequest'), scene: Scene.white, onTap: () {

            },),
            if(friend == null && newFriend == null) TextButton(text: ApplicationLocalizations.of(context).text('addFriend'),
              scene: Scene.white,
              onTap: () async {
                var data = {
                  "tenantId": sessionStore.user.tenantId,
                  "userId": this.userId
                };
                var result = await FriendApi.createFriendshipRequest(data);
                friend = Friend.fromJson(result);
                friendStore.addMyFriendRequest(friend);
              },)
          ],
        ),
      ) : null,
    );
  }
}
