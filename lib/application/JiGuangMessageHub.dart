import 'package:flutter_app/config/appConfig.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JiGuangMessageHub {
  JPush jPush;
  List<Function> handles;

  initialize() async {
    jPush = new JPush();
    jPush.setup(appKey: AppConfig.jiguangAppId ,channel: 'developer-default');
    jPush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter 接收到推送: $message");
      }
    );
  }

  sendLocalizeNotify() {
    var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 3000);
    
  }

  onReceiveMessage(handle) {

  }

  sendChatMessage(ChatMessage chatMessage) async {

  }
}