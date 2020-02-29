import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/components/NetAvatar.dart';
import 'package:canknow_flutter_ui/components/OnlineStatus.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/config/ComponentSize.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter_app/apis/session.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/MeHeaderPreviewItem.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/MenuTile.dart';
import 'package:flutter_app/models/User.dart';
import 'package:flutter_app/store/index.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/store/session.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';
import 'package:flutter_app/views/common/SignPage.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

  Future onRefresh() async {
    var sessionStore = Store.value<SessionStore>(context);
    try {
      var result = await SessionApi.getCurrentLoginInformations();
      sessionStore.setUser(User.fromJson(result["user"]));
    }
    catch (message) {
      Toast.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          buildHeader(),
          buildMenus()
        ],
      ),
    );
  }

  buildHeaderPreview() {
    return Container(
      child: Row(
        children: <Widget>[
          MeHeadPreviewItem(name: ApplicationLocalizations.of(context).text('followers'), number: 100, handle: () {

          },),
          MeHeadPreviewItem(name:  ApplicationLocalizations.of(context).text('follows'), number: 100, handle: () {

          }),
          MeHeadPreviewItem(name:  ApplicationLocalizations.of(context).text('orders'), number: 100, handle: () {

          }),
        ],
      ),
    );
  }

  buildHeaderProfile() {
    var sessionStore = Store.value<SessionStore>(context);
    var appStore = Store.value<AppStore>(context);
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding, vertical: Variables.contentPaddingLarge),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/header_bg.jpg"),
            fit: BoxFit.cover,
          ),
//          color: themeData.primaryColor
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width: Variables.componentSizeLarger,
                  height: Variables.componentSizeLarger,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RawMaterialButton(
                      onPressed: () {
                        ApplicationNavigatorUtil.gotoPictureViewPage(context, ApplicationUtil.getFilePath(sessionStore.user.avatar));
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Stack(
                        children: <Widget>[
                          NetAvatar(ApplicationUtil.getFilePath(sessionStore.user?.avatar), size: Variables.componentSizeLarger,),
                          Align(
                            child: OnlineStatus(status: appStore.onlineStatus,),
                            alignment: Alignment.bottomRight,
                          )
                        ],
                      )
                  )
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (sessionStore.user!=null) Text(sessionStore.user?.nickName??"appUser", style: TextStyle(color: themeData.primaryTextTheme.title.color, fontWeight: FontWeight.bold, fontSize: Variables.fontSize)),
                  ],
                ),
              ),
              Container(
                child: ApplicationIconButton(
                  onTap: () {
                    Navigator.of(context).pushNamed("/settings");
                  },
                  plain: true,
                  size: ComponentSize.smaller,
                  scene: Scene.white,
                  icon: ApplicationIcon('setting'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  buildUnAuthorizationHeader() {
    return Container(
      padding: EdgeInsets.all(Variables.contentPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/un-authorized-user-header-background.png'),
        )
      ),
      height: Variables.componentSizeHuge,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(text: "点击登录", border: true,scene: Scene.primary, circle: true, onTap: () {
            Navigator.of(context).pushNamed('/login');
          },)
        ],
      ),
    );
  }

  buildHeader(){
    if (AuthorizationService.isAuthorized) {
      return Column(
        children: <Widget>[
          buildHeaderProfile(),
          buildHeaderPreview(),
        ],
      );
    }
    else {
      return buildUnAuthorizationHeader();
    }
  }

  buildMenus() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          MenuTile(ApplicationLocalizations.of(context).text("myOrder"), icon: 'order', handle: (){
            Navigator.of(context).pushNamed("/order");
          }),
          MenuTile(ApplicationLocalizations.of(context).text("articleCollection"), icon: 'article', handle: (){
            Navigator.of(context).pushNamed("/order");
          })
        ],
      ),
    );
  }
}

class TopBarClipper extends CustomClipper<Path> {
  // 宽高
  double width;
  double height;

  TopBarClipper(this.width, this.height);

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(width, 0.0);
    path.lineTo(width, height / 2);
    path.lineTo(0.0, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}