import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/Input.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';
import 'package:flutter/material.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/MainInputBody.dart';
import 'package:provider/provider.dart';

class ChangeStatementPage extends StatefulWidget {
  @override
  _ChangeStatementPageState createState() => new _ChangeStatementPageState();
}

class _ChangeStatementPageState extends State<ChangeStatementPage> {
  FocusNode focusNode = new FocusNode();
  String initContent;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Variables.appBarColor,
      appBar: ApplicationAppBar(
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Variables.appBarColor,
          title: Text('更改签名')),
      body: MainInputBody(
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Input(focusNode: this.focusNode),
                Container(
                  padding: EdgeInsets.all(Variables.contentPadding),
                  child: Text('好名字可以让你的朋友更容易记住你', style: TextStyle(fontSize: Variables.fontSizeSmall),),
                ),
              ],
            )
        ),
      ),
    );
  }
}
