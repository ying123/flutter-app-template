import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/components/InfoListTile.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/file.dart';
import 'package:flutter_app/apis/profile.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:flutter_app/store/index.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter_app/store/session.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';
import 'package:flutter_app/views/areas/me/ChangeNickNamePage.dart';
import 'package:flutter_app/views/areas/me/ChangeSteatementPage.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        centerTitle: true,
        borderColor: Colors.transparent,
        title: Text(ApplicationLocalizations.of(context).text('profile')),
      ),
      body: ListView(
        children: <Widget>[
          buildHeader(),
          buildList(),
        ],
      )
    );
  }

  Future uploadAvatar() async {
    File image = await ImageUtil.getGalleryImage();
    if (image == null) {
      return;
    }
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY:1),
        compressQuality: 60,
        maxHeight: 100,
        maxWidth: 100,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
        )
    );
    Toast.loading(context);
    try {
      var result = await FileApi.uploadFile(croppedFile);
      await ProfileApi.updateAvatar({
        "filePath": result["path"]
      });
      var sessionStore = Store.value<SessionStore>(context);
      sessionStore.user.avatar = result["path"];
      sessionStore.setUser(sessionStore.user);
    }
    catch (e) {
      Toast.error(context, e.getMessage());
    }
    finally {
      Toast.dismiss();
    }
  }

  buildHeader(){
    final ThemeData themeData = Theme.of(context);
    var sessionStore = Store.value<SessionStore>(context);
    return Container(
      padding: EdgeInsets.all(Variables.contentPadding),
      decoration: BoxDecoration(color: themeData.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(Variables.contentPadding),
            child: GestureDetector(
              onTap: uploadAvatar,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: ApplicationUtil.getFilePath(sessionStore.user.avatar),
                  fit: BoxFit.cover,
                  width: Variables.componentSizeLargest,
                  height: Variables.componentSizeLargest,
                  errorWidget: (context, url, error) => Image.asset('assets/images/avatar.png',
                    width: Variables.componentSizeLargest,
                    height: Variables.componentSizeLargest,),
                ),
              ),
            ),
          ),
          Container(
            child: Text(sessionStore.user?.nickName??"appUser", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: Variables.fontSize)),
          )
        ],
      ),
    );
  }

  buildList() {
    var sessionStore = Store.value<SessionStore>(context);
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          InfoListTile(ApplicationLocalizations.of(context).text("userName"), content: sessionStore.user.userName, nextIcon: true, handle: (){

          }),
          InfoListTile(ApplicationLocalizations.of(context).text("nickName"), content: sessionStore.user.nickName, nextIcon: true, handle: (){
            ApplicationNavigatorUtil.push(ChangeNickNamePage());
          }),
          InfoListTile(ApplicationLocalizations.of(context).text("statement"), content: '我就是我，是颜色不一样的烟火', nextIcon: true, handle: (){
            ApplicationNavigatorUtil.push(ChangeStatementPage());
          }),
          InfoListTile(ApplicationLocalizations.of(context).text("qrcode"), nextIcon: true, handle: (){
            Navigator.of(context).pushNamed('/user/qrcode');
          })
        ],
      ),
    );
  }
}
