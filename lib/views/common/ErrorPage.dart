import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails details;

  ErrorPage(this.errorMessage, this.details);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  static List<Map<String, dynamic>> sErrorStack = new List<Map<String, dynamic>>();
  static List<String> sErrorName = new List<String>();

  final TextEditingController textEditingController = new TextEditingController();

  addError(FlutterErrorDetails details) {
    try {
      var map = Map<String, dynamic>();
      map["error"] = details.toString();
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Center(
        child: Container(
          padding: EdgeInsets.all(Variables.contentPadding),
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: new Text("Error Occur", style: new TextStyle(fontSize: Variables.fontSize, color: Colors.black),),
                margin: EdgeInsets.only(bottom: Variables.componentSpanLarge),
              ),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new TextButton(
                      onTap: () {
                        String content = widget.errorMessage;
                        textEditingController.text = content;
                      },
                      scene: Scene.primary,
                      border: true,
                      circle: true,
                      text: "Report"),
                  new TextButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      scene: Scene.primary,
                      border: true,
                      circle: true,
                      text: "Back")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
