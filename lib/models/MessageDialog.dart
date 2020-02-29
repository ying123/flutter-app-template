import 'package:flutter_app/models/ChatMessage.dart';
import 'package:flutter_app/models/UserChatFriendsWithSettings.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class MessageDialog {
  final int groupId;
  final int friendUserId;
  Friend friend;
  int unreadCount;
  DateTime time;
  ChatMessage chatMessage;

  MessageDialog({
    this.groupId,
    this.friendUserId,
    this.friend,
    this.unreadCount = 0,
    this.time,
    this.chatMessage
  });
}
