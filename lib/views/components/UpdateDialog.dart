import 'dart:io';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/commonFetch.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final String version;
  final String updateInfo;
  final String updateUrl;
  final bool isForce;

  UpdateDialog({
    this.version = "1.0.0",
    this.updateInfo = "",
    this.updateUrl = "",
    this.isForce = false,
  });

  @override
  State<StatefulWidget> createState() => new UpdateDialogState();
}

class UpdateDialogState extends State<UpdateDialog> {
  int _downloadProgress = 0;
  CancelToken token;
  UpdateStatus updateStatus = UpdateStatus.idle;

  buildHeader() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/update-header-background.png'),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: Variables.contentPaddingLargest,
            child: Center(
              child: Text(widget.version, style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  buildFooter() {
    return Container(
      padding: EdgeInsets.all(Variables.contentPadding),
      child: Row(
        children: <Widget>[
          if(!widget.isForce) Expanded(
            flex: 1,
            child: TextButton(text: ApplicationLocalizations.of(context).text('common.dialog.cancel'),
                circle: true,
                border: true,
                onTap: () {
                  Navigator.of(context).pop();
                }),
          ),
          if(!widget.isForce) Spaces.hComponentSpan,
          Expanded(
            flex: 1,
            child: TextButton(
              disabled: updateStatus == UpdateStatus.updating,
              text: ApplicationLocalizations.of(context).text('update.updateRightNow'),
              border: true,
              circle: true,
              scene: Scene.error,
              onTap: () async {
                updateStatus = UpdateStatus.updating;
                if (mounted)
                  setState(() {
                  });
                if (Platform.isAndroid) {
                  _androidUpdate();
                }
                else if (Platform.isIOS) {
                  _iosUpdate();
                }
              },),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.all(Variables.componentSpan),
              child: Column(
                children: <Widget>[
                  buildHeader(),
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(Variables.borderRadiusLarger),)),
                    ),
                    child: Column(
                      children: <Widget>[
                        // 更新信息
                        Container(
                          padding: EdgeInsets.all(Variables.contentPadding),
                          alignment: Alignment.topLeft,
                          child: Material(
                            color: Colors.transparent,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(widget.updateInfo ?? "", style: TextStyle(color: Colors.black, fontSize: Variables.fontSizeSmall),),
                            ),
                          ),
                        ),
                        // 进度条
                        if(updateStatus == UpdateStatus.updating) _buildProgress(),
                        // 底部按钮
                        buildFooter()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ) ,
    );
  }

  void _androidUpdate() async {
    final apkPath = await FileUtil.getSavePath("/Download/");
    try {
      await commonFetch.dio.download(
          widget.updateUrl,
          apkPath + "canknow.apk",
          cancelToken: token,
          onReceiveProgress: (int count, int total) {
            if (mounted) {
              setState(() {
                _downloadProgress = ((count / total) * 100).toInt();
                if (_downloadProgress == 100) {
                  if (mounted) {
                    setState(() {
                      updateStatus = UpdateStatus.updated;
                    });
                  }
                  try {
                    OpenFile.open(apkPath + "canknow.apk");
                  }
                  catch (e) {

                  }
                  Navigator.of(context).pop();
                }
              });
            }
          }
      );
    }
    catch (e) {
      if (mounted) {
        setState(() {
          updateStatus = UpdateStatus.failed;
          Toast.error(context, 'downloadFailed');
        });
      }
    }
  }

  Widget _buildProgress() {
    return Container(
      padding: EdgeInsets.all(Variables.contentPadding),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        backgroundColor: Colors.grey[300],
        semanticsLabel: _downloadProgress.toString(),
        value: _downloadProgress / 100,
      ),
    );
  }

  void _iosUpdate() {
    launch(widget.updateUrl);
  }

  @override
  void initState() {
    super.initState();
    token = new CancelToken();
  }

  @override
  void dispose() {
    if (!token.isCancelled) {
      token?.cancel();
    }
    super.dispose();
  }
}

enum UpdateStatus {
  updating,
  idle,
  updated,
  failed
}
