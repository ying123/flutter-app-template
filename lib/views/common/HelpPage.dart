import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: ApplicationAppBar(
            backgroundColor: Variables.appBarColor,
            brightness: Brightness.light,
            centerTitle: true,
            title: Text(ApplicationLocalizations.of(context).text('help')),),
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: Variables.contentPadding, right: Variables.contentPadding),
                child: Image.asset('assets/images/help.png'),
              ),
              Container(
                padding: const EdgeInsets.only(top: Variables.componentSpan),
                child: Text(
                  ApplicationLocalizations.of(context).text('howCanWeHelpYou'),
                  style: TextStyle(
                    fontSize: Variables.fontSizeBig,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Variables.componentSpan),
                child: Text(
                  ApplicationLocalizations.of(context).text('helpDescription'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Variables.fontSizeSmall,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Variables.contentPadding),
                child: Center(
                  child: Container(
                      child: TextButton(text: ApplicationLocalizations.of(context).text('chatWithUs'), scene: Scene.primary,)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
