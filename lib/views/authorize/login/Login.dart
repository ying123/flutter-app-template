import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/views/authorize/login/OtherLogin.dart';
import 'package:flutter_app/views/authorize/login/PhoneLogin.dart';
import 'package:flutter_app/views/authorize/login/PhoneOnekeyLogin.dart';
import 'package:flutter_app/store/jverify.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    JverifyStore jverifyStore = Store.value<JverifyStore>(context);

    return Scaffold(
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: Variables.contentPadding),
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                SizedBox(height: kToolbarHeight),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      buildHeader(),
                      Column(
                        children: <Widget>[
                          jverifyStore.usable ? PhoneOneKeyLogin() : PhoneLogin(),
                          Container(
                            margin: EdgeInsets.only(top: Variables.componentSpanLarge),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/loginByUserName');
                              },
                              child: Text(ApplicationLocalizations.of(context).text('accountLogin'),
                                style: TextStyle(fontSize: Variables.fontSizeSmall, color: Variables.subColor),),
                            ),
                          ),
                        ],
                      ),
                      OtherLogin(),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }

  buildHeader() {
    return Container(
        child: Image.asset('assets/images/title-logo.png', height: 48,)
    );
  }
}