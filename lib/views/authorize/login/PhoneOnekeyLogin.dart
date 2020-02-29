import 'dart:io';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/Application.dart';
import 'package:flutter_app/application/JVerifyManage.dart';
import 'package:jverify/jverify.dart';

class PhoneOneKeyLogin extends StatefulWidget {
  @override
  _PhoneOneKeyLoginState createState() => _PhoneOneKeyLoginState();
}

class _PhoneOneKeyLoginState extends State<PhoneOneKeyLogin> {
  bool submitting = false;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    JVerifyManage().preLogin(context).then((result) {
      setState(() {
        this.enabled = result;
      });
      if (result) {
        var uiConfig = setUI();
        JVerifyManage().jverify.setCustomAuthorizationView(true, uiConfig, landscapeConfig: uiConfig);
      }
    });
  }

  setUI() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    bool isiOS = Platform.isIOS;

    JVUIConfig uiConfig = JVUIConfig();
    //uiConfig.authBackgroundImage = ;
    // uiConfig.navHidden = true;
    uiConfig.navColor = Colors.red.value;
    uiConfig.navText = "coding01登录";
    uiConfig.navTextColor = Colors.blue.value;
    uiConfig.navReturnImgPath = "return_bg";//图片必须存在

//    uiConfig.logoWidth = 100;
//    uiConfig.logoHeight = 100;
//    //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
//    uiConfig.logoOffsetY = 10;
//    uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
//    uiConfig.logoHidden = false;
//    uiConfig.logoImgPath = "logo";
//
//    uiConfig.numberFieldWidth = 200;
//    uiConfig.numberFieldHeight = 40 ;
//    //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
//    uiConfig.numFieldOffsetY = isiOS ? 20 : 120;
//    uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
//    uiConfig.numberColor = Colors.blue.value;
//    uiConfig.numberSize = 18;
//
//    uiConfig.sloganOffsetY = isiOS ? 20 : 160;
//    uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
//    uiConfig.sloganTextColor = Colors.black.value;
//    uiConfig.sloganTextSize = 15;
//    //uiConfig.sloganHidden = 0;
//
//    uiConfig.logBtnWidth = 220;
//    uiConfig.logBtnHeight = 50;
//    //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
//    uiConfig.logBtnOffsetY = isiOS ? 20 : 230;
//    uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
//    uiConfig.logBtnText = "登录按钮";
//    uiConfig.logBtnTextColor = Colors.brown.value;
//    uiConfig.logBtnTextSize = 16;
//    uiConfig.loginBtnNormalImage = "login_btn_normal";//图片必须存在
//    uiConfig.loginBtnPressedImage = "login_btn_press";//图片必须存在
//    uiConfig.loginBtnUnableImage = "login_btn_unable";//图片必须存在


//    uiConfig.privacyState = true;//设置默认勾选
//    uiConfig.privacyCheckboxSize = 20;
//    uiConfig.checkedImgPath = "check_image";//图片必须存在
//    uiConfig.uncheckedImgPath = "uncheck_image";//图片必须存在
//    uiConfig.privacyCheckboxInCenter = true;
    //uiConfig.privacyCheckboxHidden = false;

    // uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
//    uiConfig.privacyOffsetY = 15;// 距离底部距离
//    uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
//    uiConfig.clauseName = "协议1";
//    uiConfig.clauseUrl = "http://www.baidu.com";
//    uiConfig.clauseBaseColor = Colors.black.value;
//    uiConfig.clauseNameTwo = "协议二";
//    uiConfig.clauseUrlTwo = "http://www.hao123.com";
//    uiConfig.clauseColor = Colors.red.value;
//    uiConfig.privacyText = ["1极","2光","3认","4证"];
//    uiConfig.privacyTextSize = 13;

    //uiConfig.privacyWithBookTitleMark = true;
    // uiConfig.privacyTextCenterGravity = false;

//    uiConfig.privacyNavColor =  Colors.red.value;;
//    uiConfig.privacyNavTitleTextColor = Colors.blue.value;
//    uiConfig.privacyNavTitleTextSize = 16;
//    uiConfig.privacyNavTitleTitle1 = "协议1 web页标题";
//    uiConfig.privacyNavTitleTitle2 = "协议2 web页标题";
//    uiConfig.privacyNavReturnBtnImage = "return_bg";//图片必须存在;
    return uiConfig;
  }

  Future login() async {
    setState(() {
      this.submitting = true;
    });
    var result = await JVerifyManage().jverify.loginAuth(true);
    Toast.show(context, result["message"]);
    setState(() {
      this.submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: Variables.componentSpanLarge),
            padding: EdgeInsets.all(Variables.contentPadding),
            child: Text(TextUtil.encryptedMobile('15927051130'), style: TextStyle(fontSize: Variables.fontSizeBig),),
          ),
          TextButton(
            text: ApplicationLocalizations.of(context).text('oneKeyLogin'),
            loading: submitting,
            disabled: !enabled,
            scene: Scene.primary,
            onTap: () async {
            await this.login();
          },)
        ],
      )
    );
  }
}
