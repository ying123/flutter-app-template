import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  final title;
  final message;

  NotFoundPage({this.title = "No Result", this.message = "Try a more general keyword."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}