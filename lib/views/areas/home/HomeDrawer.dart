import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(title: Text('text'),),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.red
        ),
      ),
    );
  }
}
