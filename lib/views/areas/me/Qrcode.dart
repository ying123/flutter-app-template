import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/store/index.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:flutter_app/views/areas/me/PersonCard.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_app/store/session.dart';

class Qrcode extends StatefulWidget {
  @override
  _QrcodeState createState() => _QrcodeState();
}

class _QrcodeState extends State<Qrcode> {
  GlobalKey repaintKey = GlobalKey();

  capture() async {

  }

  @override
  Widget build(BuildContext context) {
    var sessionStore = Store.value<SessionStore>(context);
    return Scaffold(
      appBar: new ApplicationAppBar(
        centerTitle: true,
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        title: new Text("二维码名片"),
      ),
      body: RepaintBoundary(
        key: repaintKey,
        child: Column(
          children: <Widget>[
            PersonCard(user: sessionStore.user),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: Variables.componentSpan),
                    alignment: Alignment.center,
                    child: QrImage(
                      data: "这里是需要生成二维码的数据",
                      size: 200.0,
                      embeddedImage: NetworkImage(ApplicationUtil.getFilePath(sessionStore.user.avatar)),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(48, 48),
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('扫一扫上面的二维码图片加我好友', style: TextStyle(color: Variables.subColor, fontSize: Variables.fontSizeSmall),),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Variables.contentPadding),
              child: TextButton(text: 'save qrcode', border: true, circle: true, onTap: () {
                capture();
              },),
            )
          ],
        ),
      ),
    );
  }
}
