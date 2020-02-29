import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/Application.dart';
import 'package:flutter_app/store/app.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  List<Color> themeColors;

  @override
  void initState() {
    super.initState();
    themeColors = ApplicationUtil.getThemeListColor();
  }

  buildGrid() {
    var appStore = Store.value<AppStore>(context);
    return GridView.builder(
        shrinkWrap: true,
        itemCount: themeColors.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: Variables.componentSpan,
          crossAxisSpacing: Variables.componentSpan,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ApplicationUtil.pushTheme(appStore, index);
            },
            child:  Container(
                height: Variables.componentSize,
                color: themeColors != null ? themeColors[index] : Theme.of(context).primaryColor
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(ApplicationLocalizations.of(context).text('themeSetting')),
      ),
      body: Container(
        padding: EdgeInsets.all(Variables.contentPadding),
        child: buildGrid(),
      ),
    );
  }
}
