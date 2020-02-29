import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/CellButton.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/MenuTile.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/SettingTile.dart';
import 'package:flutter_app/config/globalConfig.dart';

class SettingPage extends StatelessWidget {

  buildMenus(context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          SettingTile(ApplicationLocalizations.of(context).text("profile"), handle: (){
            Navigator.of(context).pushNamed("/user/myProfile");
          }),
          if (GlobalConfig.showLanguagesSetting) SettingTile(ApplicationLocalizations.of(context).text("languagesSetting"), handle: (){
            Navigator.of(context).pushNamed("/languages");
          }),
          if (GlobalConfig.showThemeSetting) SettingTile(ApplicationLocalizations.of(context).text("themeSetting"), handle: (){
            Navigator.of(context).pushNamed("/settings/theme");
          }),
          SettingTile(ApplicationLocalizations.of(context).text("aboutUs"), handle: (){
            Navigator.of(context).pushNamed("/about");
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(ApplicationLocalizations.of(context).text('settings')),
      ),
      body: Column(
        children: <Widget>[
          buildMenus(context),
          Spaces.vComponentSpan,
          Container(
            child: CellButton(
              scene: Scene.error,
              onTap: () {
                AuthorizationService.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', ModalRoute.withName('/'));
              },
              text: ApplicationLocalizations.of(context).text('logout'),
            ),
          )
        ],
      ),
    );
  }
}
