import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/utils/ApplicationUtil.dart';
import 'package:flutter_app/utils/ApplicatoinNavigatorUtil.dart';

class ImageMessageBody extends StatelessWidget {
  final ChatMessage chatMessage;

  ImageMessageBody(this.chatMessage);

  @override
  Widget build(BuildContext context) {
    double size = 120;
    Widget image = Image.network(
      ApplicationUtil.getFilePath(chatMessage.url),
      width: size,
      height: size,
      fit: BoxFit.fill,
    );

    return GestureDetector(
      onTap: () {
        ApplicationNavigatorUtil.gotoPictureViewPage(context, ApplicationUtil.getFilePath(chatMessage.url));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Variables.borderRadiusLarge),
        child: Container(
          color: chatMessage.side == ChatSide.Sender ? Colors.white : Color.fromARGB(255, 158, 234, 106),
          child: image,
        ),
      ),
    );
  }
}
