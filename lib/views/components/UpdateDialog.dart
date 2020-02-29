import 'dart:io';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/apis/commonFetch.dart';
import 'package:canknow_flutter_ui/components/ApplicationDialogHeader.dart';
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
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Variables.blockBorderRadius),)),
              ),
              child: Column(
                children: <Widget>[
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
                  _buildLoading(),
                  Container(
                    padding: EdgeInsets.all(Variables.contentPadding),
                    child: Row(
                      children: <Widget>[
                        if(!widget.isForce) Expanded(
                          flex: 1,
                          child: TextButton(text: ApplicationLocalizations.of(context).text('common.dialog.cancel'),
                              ghost: true,
                              onTap: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                        if(!widget.isForce) Spaces.hComponentSpan,
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            disabled: updateStatus == UpdateStatus.updating,
                            text: ApplicationLocalizations.of(context).text('update.update'),
                            border: true,
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

  Widget _buildLoading() {
    if (updateStatus == UpdateStatus.updating) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.all(Variables.contentPadding),
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            backgroundColor: Colors.grey[300],
            semanticsLabel: _downloadProgress.toString(),
            value: _downloadProgress / 100,
          ),
        ),
        flex: 1,
      );
    }
    return Container();
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
