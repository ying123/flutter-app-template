import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/ApplicationListTile.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/application/Application.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/MenuTile.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/SearchBar.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        centerTitle: true,
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        title: Text(ApplicationLocalizations.of(context).text('addFriend')),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(Variables.contentPadding),
            child: SearchBar(
              color: Variables.backgroundColor,
              search: () {
                Navigator.of(context).pushNamed('/friend/search');
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: ListView(
                children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: ApplicationIcon('scan', size: Variables.componentSize,),
                          title: Text(ApplicationLocalizations.of(context).text('scan')),
                          subtitle: Text(ApplicationLocalizations.of(context).text('scanQrcodeCard'), style: TextStyle(fontSize: Variables.fontSizeSmall),),
                          trailing: ApplicationIcon('next', size: Variables.componentSizeSmaller),
                          onTap: () async {
                            try {
                              String photoScanResult = await scanner.scan();
                              print(photoScanResult);
                            }
                            catch (e) {
                              print(e);
                            }
                          },
                        ),
                      )
                    ]
                ).toList(),
              ),),
          )
        ],
      ),
    );
  }
}
