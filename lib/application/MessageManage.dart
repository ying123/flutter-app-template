import 'dart:io';
import 'package:canknow_flutter_ui/utils/EventBus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/apis/file.dart';
import 'package:flutter_app/application/MessageHub.dart';
import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/models/MessageContentType.dart';
import 'package:flutter_app/models/MessageStatus.dart';
import 'package:flutter_app/models/MessageType.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:flutter_app/store/index.dart';
import '../store/session.dart';
import '../store/chat.dart';

class MessageManage {
  BuildContext context;

  MessageManage._internal();

  static MessageManage _singleton = new MessageManage._internal();
  factory MessageManage() => _singleton;

  initialize(context) async {
    this.context = context;
    try {
      await MessageHub().initialize(context);
    }
    catch(e) {

    }
  }

  handleEvents() {
    EventBus().on('receiveChatMessage', (chatMessage) {
      this._onReceiveMessage(chatMessage);
    });
  }

  _onReceiveMessage(ChatMessage chatMessage) {
    ChatStore chatStore = Store.value<ChatStore>(context);
    chatStore.onReceiveMessage(chatMessage);
  }

  ChatMessage buildTextMessage(String content) {
    ChatMessage chatMessage = new ChatMessage(
        type: MessageType.Chat,
        contentType: MessageContentType.Text,
        content: content, //如果是assets里的图片，则这里是assets图片的路径
        );

    return chatMessage;
  }

  buildImageMessage(File file, bool sendOriginalImage) async {
    var result = await FileApi.uploadFile(file);
    ChatMessage chatMessage = new ChatMessage(
        type: MessageType.Chat,
        contentType: MessageContentType.Image,
        content: '',
      url: result["path"]
    );
    return chatMessage;
  }

  buildVoiceMessage(File file, int length) async {
    ChatMessage chatMessage = new ChatMessage(
        type: MessageType.Chat,
        contentType: MessageContentType.Audio,
    );
    chatMessage.url = file.path;
    chatMessage.length = length;
  }

  buildVideoMessage(Map file) async {
    ChatMessage chatMessage = new ChatMessage(
        type: MessageType.Chat,
        contentType: MessageContentType.Video,
    );
    chatMessage.url = file['videoPath'];
    chatMessage.thumbPath = file['thumbPath'];
    chatMessage.length = int.parse(file['length']) + 1;
  }

  sendMessage(ChatMessage chatMessage, BuildContext context, Friend friend) async {
    var chatStore = Store.value<ChatStore>(context);
    var sessionStore = Store.value<SessionStore>(context);

    chatMessage.userId = sessionStore.user.id;
    chatMessage.targetUserId = friend.friendUserId;
    chatMessage.creationTime = new DateTime.now();
    chatMessage.side = ChatSide.Sender;
    chatMessage.readState = ChatMessageReadState.Unread;
    chatMessage.receiverReadState = ChatMessageReadState.Unread;
    chatMessage.latitude = 0;
    chatMessage.longitude = 0;
    chatMessage.status = MessageStatus.Sending;

    chatStore.sendMessage(chatMessage);
    try {
      await MessageHub().sendChatMessage(chatMessage);
      chatStore.completeSendMessage(chatMessage);
    }
    catch (e) {
      chatStore.failSendMessage(chatMessage);
    }
  }
  
  resendMessage(ChatMessage chatMessage, BuildContext context) async {
    var chatStore = Store.value<ChatStore>(context);
    chatStore.resendMessage(chatMessage);
    try {
      await MessageHub().sendChatMessage(chatMessage);
      chatStore.completeSendMessage(chatMessage);
    }
    catch (e) {
      chatStore.failSendMessage(chatMessage);
    }
  }
}