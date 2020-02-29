import 'package:canknow_flutter_ui/components/ApplicationIconButton.dart';
import 'package:canknow_flutter_ui/config/ComponentSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/styles/appColors.dart';
import 'package:canknow_flutter_ui/components/SectionTitle.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_app/apis/account.dart';

class OtherLogin extends StatefulWidget {
  @override
  _OtherLoginState createState() => _OtherLoginState();
}

class _OtherLoginState extends State<OtherLogin> {
  List _loginProviders = [
    {
      "title": "QQ",
      "icon": "qq",
      "color": AppColors.qqColor,
      "textColor": AppColors.qqTextColor,
      "handle": (context) {
        Toast.success(context, "test");
      }
    },
    {
      "title": "Wechat",
      "icon": "wechat",
      "color": AppColors.weixinColor,
      "textColor": AppColors.weixinTextColor,
      "handle": (context) {
        fluwx.sendWeChatAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test").then((data) {

        }).catchError((e){
          print('weChatLogin  e  $e');
        });
      }
    }
  ];

  @override
  void initState() {
    super.initState();

    fluwx.responseFromAuth.listen((data) async {
      if (data.code!=null) {
        try {
          var result = await AccountApi.loginByCode({
            'code': data.code,
            'tenancyName': AppConfig.TenancyName
          });
          AuthorizationService.setToken(result['accessToken']);
          Navigator.of(context).pushReplacementNamed('/index');
        }
        catch (e) {
          Toast.error(context, e);
        }
      }
    }, onError: (e) {
      Toast.error(context, e.message);
    });
  }

  buildOtherLoginItem(item) {
    return ApplicationIconButton(
      size: ComponentSize.large,
        border: true,
        circle: true,
        icon: ApplicationIcon(item['icon'], color: item['textColor']),
        onTap: () {
          item['handle'](context);
        }
    );
  }

  buildLoginProviders(context) {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.center,
            child: SectionTitle(ApplicationLocalizations.of(context).text('otherLoginMethods'))),
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: _loginProviders.map((item) => Builder(
            builder: (context) {
              return buildOtherLoginItem(item);
            },
          )).toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Variables.contentPadding),
      child: buildLoginProviders(context),
    );
  }
}
