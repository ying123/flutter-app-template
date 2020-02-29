import 'package:flutter/material.dart';
import 'package:flutter_app/models/ChatMessage.dart';

class VoiceMessageBody extends StatelessWidget {
  final ChatMessage chatMessage;

  VoiceMessageBody(this.chatMessage);

  @override
  Widget build(BuildContext context) {
    double width;
    if (chatMessage.length < 5000) {
      width = 90;
    }
    else if (chatMessage.length < 10000) {
      width = 140;
    }
    else if (chatMessage.length < 20000) {
      width = 180;
    }
    else {
      width = 200;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          width: width,
          color: chatMessage.side == ChatSide.Sender ? Colors.white : Color.fromARGB(255, 158, 234, 106),
          child: Row(
            mainAxisAlignment: chatMessage.side == ChatSide.Sender ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              chatMessage.side == ChatSide.Sender ? Text('') : Text((chatMessage.length ~/ 1000).toString() + 's', style: TextStyle(fontSize: 18, color: Colors.black)),
              SizedBox(width: 5,),
              chatMessage.isVoicePlaying ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 1, right: 1),
                width: 18.0,
                height: 18.0,
                child: SizedBox(
                    width: 14.0,
                    height: 14.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                      strokeWidth: 2,
                    )),
              ) : Image.asset(
                'audio',
                width: 18,
                height: 18,
                color: Colors.black,
              ),
              SizedBox(width: 5,),
              chatMessage.side == ChatSide.Sender ? Text((chatMessage.length ~/ 1000).toString() + 's', style: TextStyle(fontSize: 18, color: Colors.black)) : Text(''),
            ],
          )),
    );
  }
}
