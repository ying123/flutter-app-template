import 'package:flutter_app/models/MessageContentType.dart';
import 'package:flutter_app/models/MessageStatus.dart';
import './../models/MessageType.dart';
import './../models/ChatMessage.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SendChatMessageInput extends Object {
  @JsonKey(name: 'groupId')
  int groupId;

  @JsonKey(name: 'targetUserId')
  int targetUserId;

  @JsonKey(name: 'targetTenantId')
  int targetTenantId;

  @JsonKey(name: 'contentType')
  MessageContentType contentType;

  MessageStatus status;

  @JsonKey(name: 'content')
  String content;

  int length;

  bool isVoicePlaying = false;

  @JsonKey(name: 'thumbPath')
  String thumbPath;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'latitude')
  double latitude;

  @JsonKey(name: 'longitude')
  double longitude;

  // 消息类型（0：单聊，1：群组）
  @JsonKey(name: 'type')
  MessageType type;

  @JsonKey(name: 'creationTime')
  DateTime creationTime;

  @JsonKey(name: 'side')
  ChatSide side;

  @JsonKey(name: 'readState')
  ChatMessageReadState readState;

  @JsonKey(name: 'receiverReadState')
  ChatMessageReadState receiverReadState;

  SendChatMessageInput({this.targetUserId,this.targetTenantId,this.contentType,this.content,this.thumbPath,this.url,this.latitude,this.longitude,this.type,this.creationTime,this.side,this.readState,this.receiverReadState});
}