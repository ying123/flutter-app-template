import 'package:canknow_flutter_ui/components/popupMenu/PopupMenu.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/material.dart';
import 'file:///G:/project/canknow/canknow_flutter_ui/lib/components/ChatBubble.dart';
import 'package:flutter_app/models/ChatMessage.dart';

class TextMessageBody extends StatelessWidget {
  final ChatMessage chatMessage;

  TextMessageBody(this.chatMessage);

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      actions: ['copy', 'collect', 'delete'],
      onValueChanged: (value) {

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Variables.borderRadiusLarge),
          color: chatMessage.side == ChatSide.Receiver ? Colors.white : Variables.primaryColor,
        ),
        padding: EdgeInsets.symmetric(horizontal:  Variables.contentPadding, vertical: Variables.contentPaddingSmall),
        child: Text(
          chatMessage.content,
          style: TextStyle(fontSize: Variables.fontSize, color: chatMessage.side == ChatSide.Receiver ? Variables.contentColor : Colors.white),
        ),
      ),
    );
  }
}
