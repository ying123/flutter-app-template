import 'package:canknow_flutter_ui/components/applicationAppBar/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/codeInput/CodeInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/account.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';

class Captcha extends StatefulWidget {
  @override
  _CaptchaState createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  bool isSubmitButtonDisabled = true;
  String _phoneNumber;
  String code;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    this._phoneNumber = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: ApplicationAppBar(),
      body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: Variables.componentSpan),
                      alignment: Alignment.centerLeft,
                      child: Text(ApplicationLocalizations.of(context).text('pleaseInputCaptcha'), style: TextStyle(fontSize: Variables.fontSizeLarge),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Variables.componentSpan),
                      alignment: Alignment.centerLeft,
                      child: Text.rich(TextSpan(
                        children: [
                          TextSpan(text: "短信验证码已经发送到"),
                          TextSpan(text: _phoneNumber, style: TextStyle(fontWeight: FontWeight.bold)),
                        ]
                      ))
                    ),
                    SizedBox(height: 96),
                    Padding(
                      padding: EdgeInsets.only(left: Variables.contentPaddingLarge, right: Variables.contentPaddingLarge, bottom: Variables.componentSpan),
                      child: CodeInput(
                        context: context,
                        onFilled: (String value){

                        },
                        onChanged: (String value) {
                          setState(() {
                            code = value;
                            isSubmitButtonDisabled = value == null || !value.isNotEmpty || value.length < 4;
                          });
                        },
                      ),
                    ),
                    buildSubmitButton(context)
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Function _getSubmitButtonClickListener() {
    if (!isSubmitButtonDisabled) {
      return () {
        handleSubmit();
      };
    }
    return null;
  }

  handleSubmit() async {
    this.setState(() {
      this.loading = true;
    });
    try {
      var result = await AccountApi.loginByPhoneNumber({
        "phoneNumber": this._phoneNumber,
        "captcha": this.code,
        "tenancyName": AppConfig.TenancyName
      });
      AuthorizationService.setToken(result['accessToken']);
      ApplicationNavigatorUtil.landing();
    }
    catch(e) {
      Toast.error(context, e.error);
    }
    finally{
      this.setState(() {
        this.loading = false;
      });
    }
  }

  buildSubmitButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: Variables.componentSizeLarge,
        width: double.infinity,
        child: TextButton(
            loading: loading,
            disabled: isSubmitButtonDisabled,
            scene: Scene.primary,
            text: ApplicationLocalizations.of(context).text('login'),
            onTap: _getSubmitButtonClickListener()
        ),
      ),
    );
  }
}
