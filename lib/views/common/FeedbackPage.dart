import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
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
            title: Text(ApplicationLocalizations.of(context).text('feedback')),),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: Variables.contentPadding, right: Variables.contentPadding),
                  child: Image.asset('assets/images/feedback.png'),
                ),
                Container(
                  padding: const EdgeInsets.only(top: Variables.componentSpan),
                  child: Text(ApplicationLocalizations.of(context).text('yourFeedback'),
                    style: TextStyle(fontSize: Variables.fontSizeBig, fontWeight: FontWeight.bold,),),
                ),
                Container(
                  padding: const EdgeInsets.only(top: Variables.componentSpan),
                  child: Text(ApplicationLocalizations.of(context).text('giveYourBestTimeForThisMoment'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Variables.fontSizeSmall,),),
                ),
                _buildComposer(),
                Padding(
                  padding: const EdgeInsets.all(Variables.componentSpan),
                  child: Center(
                      child: TextButton(
                          text: ApplicationLocalizations.of(context).text('common.actions.submit'),
                          scene: Scene.primary,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          })
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: Variables.contentPadding, left: Variables.contentPadding, right: Variables.contentPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Variables.borderColor),
          borderRadius: BorderRadius.circular(Variables.borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(Variables.textPadding),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: Variables.contentPadding, right: Variables.contentPadding, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {},
                style: TextStyle(fontSize: Variables.fontSize,),
                cursorColor: Variables.primaryColor,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: Variables.fontSizeSmall),
                    hintText: ApplicationLocalizations.of(context).text('enterYourFeedback')),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
