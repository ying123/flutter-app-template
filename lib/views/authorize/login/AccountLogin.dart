import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/Cell.dart';
import 'package:canknow_flutter_ui/components/Input.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/vendors/signalr/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/account.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:flutter_app/config/appConfig.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';

class AccountLogin extends StatefulWidget {
  @override
  _AccountLoginState createState() => _AccountLoginState();
}

class _AccountLoginState extends State<AccountLogin> {
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var enabled = false;
  var loading = false;
  var _password = '';
  var _userName = '';

  submit() async {
    this.setState(() {
      this.loading = true;
    });
    try{
      var result = await AccountApi.login({
        "tenancyName": AppConfig.TenancyName,
        "userNameOrEmailAddress": _userName,
        "password": _password
      });
      AuthorizationService.setToken(result['accessToken']);
      ApplicationNavigatorUtil.landing();
    }
    catch (e) {
      Toast.error(context, e.message);
    }
    finally{
      this.setState(() {
        this.loading = false;
      });
    }
  }

  @override
  void initState() {
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassword.addListener(_focusNodeListener);
    super.initState();
  }

  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      _focusNodePassword.unfocus();
    }
    if (_focusNodePassword.hasFocus) {
      _focusNodeUserName.unfocus();
    }
  }

  String validateUserName(value){
    if (value.isEmpty) {
      return '用户名不能为空';
    }
    return null;
  }

  String validatePassword(value){
    if (value.isEmpty) {
      return '密码不能为空';
    }
    return null;
  }

  _validate() {
    bool hasError = false;
    String message = validateUserName(_userName);
    hasError = !isStringEmpty(message) || hasError;
    message = validatePassword(_password);
    hasError = !isStringEmpty(message) || hasError;
    setState(() {
      this.enabled = !hasError;
    });
  }

  buildHeader() {
    return Container(
      padding: EdgeInsets.all(Variables.contentPadding),
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/images/title-logo.png",
        height: Variables.componentSizeLarge,
        fit: BoxFit.cover,
      ),
    );
  }

  buildLoginButton() {
    return Container(
      margin: EdgeInsets.all(Variables.contentPadding),
      child:  TextButton(
        text: ApplicationLocalizations.of(context).text('login'),
        loading: loading,
        disabled: !enabled,
        scene: Scene.primary,
        onTap: () async {
          _focusNodePassword.unfocus();
          _focusNodeUserName.unfocus();
          _formKey.currentState.save();
          await submit();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildHeader(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: new Form(
                key: _formKey,
                onChanged: () {
                  this._validate();
                },
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Cell(
                      child: Input(
                        focusNode: _focusNodeUserName,
                        prefixIcon: ApplicationIcon('user', size: Variables.componentSizeSmaller),
                        placeholder: ApplicationLocalizations.of(context).text('pleaseInputUserName'),
                        onChanged: (String value){
                          _userName = value;
                        },),
                    ),
                    Cell(
                      child: Input(
                        focusNode: _focusNodePassword,
                        prefixIcon: ApplicationIcon('lock', size: Variables.componentSizeSmaller,),
                        placeholder: ApplicationLocalizations.of(context).text('pleaseInputPassword'),
                        onChanged: (String value){
                          _password = value;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            buildLoginButton()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassword.removeListener(_focusNodeListener);
    super.dispose();
  }
}
