import 'dart:io';

import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/ChatBubble.dart';
import 'package:flutter_app/models/ChatMessage.dart';

class VideoMessageBody extends StatelessWidget {
  final ChatMessage chatMessage;

  VideoMessageBody(this.chatMessage);

  @override
  Widget build(BuildContext context) {
    double size = 120;
    Widget image;
    if (chatMessage.thumbPath.isNotEmpty && chatMessage.thumbPath.contains('/storage/emulated/0')) {
      if (File(chatMessage.thumbPath).existsSync()) {
        image = Image.asset(
          chatMessage.thumbPath,
          width: size,
          height: size,
          fit: BoxFit.fill,
        );
      }
      else {
        image = Image.asset(
          'default',
          width: size,
          height: size,
          fit: BoxFit.fill,
        );
      }
    }
    else if (CommonUtil.isNetUri(chatMessage.thumbPath)) {
      image = Image.network(
        chatMessage.thumbPath,
        width: size,
        height: size,
        fit: BoxFit.fill,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: chatMessage.side == ChatSide.Sender ? Colors.white : Color.fromARGB(255, 158, 234, 106),
        child: Stack(
          children: <Widget>[
            image,
            Container(
              padding: EdgeInsets.all(40),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 90, top: 98),
              child: Text(
                '${chatMessage.length}秒',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
