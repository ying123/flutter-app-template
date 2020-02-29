import 'package:flutter/material.dart';
import 'package:flutter_app/application/AppHelper.dart';
import 'package:flutter_app/application/Application.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter_app/models/CheckUpdateResult.dart';
import 'package:flutter_app/views/components/UpdateDialog.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool checkingVersion = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        centerTitle: true,
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        title: Text(ApplicationLocalizations.of(context).text('aboutUs'),),
      ),
      body: Container(
        padding: EdgeInsets.all(Variables.contentPadding),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/title-logo.png', height: 48,),
            ),
            Container(
              margin: EdgeInsets.only(top: Variables.componentSpan),
              alignment: Alignment.center,
              child: Text(ApplicationLocalizations.of(context).text("appName"), style: TextStyle(fontSize: Variables.fontSize),),
            ),
            Container(
              margin: EdgeInsets.only(top: Variables.componentSpan),
              alignment: Alignment.center,
              child: Text("v${Application.version}", style: TextStyle(fontSize: Variables.fontSize, color: Variables.propertyColor),),
            ),
            Container(
              margin: EdgeInsets.only(top: Variables.componentSpanLarge),
              child: TextButton(text: ApplicationLocalizations.of(context).text('checkUpdate'), loading: checkingVersion, scene: Scene.primary, onTap: () async {
                setState(() {
                  this.checkingVersion = true;
                });
                CheckUpdateResult checkUpdateResult = await AppHelper.checkUpdate(context, showMessage: true);
                setState(() {
                  this.checkingVersion = false;
                });
                if (checkUpdateResult!=null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateDialog(
                          version: checkUpdateResult.appVersion,
                          updateUrl: checkUpdateResult.downloadUrl,
                          updateInfo: checkUpdateResult.updateInfo,
                        );
                      });
                }
              },),
            ),
            Container(
              margin: EdgeInsets.only(top: Variables.componentSpanLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(text: ApplicationLocalizations.of(context).text('feedback'), border: true, circle:true, onTap: () {
                    Navigator.of(context).pushNamed("/common/feedback");
                  },),
                  TextButton(text: ApplicationLocalizations.of(context).text('help'),border: true, circle:true, onTap: () {
                    Navigator.of(context).pushNamed("/common/help");
                  },)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
