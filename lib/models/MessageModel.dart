import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class MessageModel {
  final String content;//消息内容(如果内容是图片，这里就是URL)
  final String fromUserName;//发消息者
  final String toUserName;//接收者
  final String id;//消息唯一ID
  final int    messageType;//消息类型（1：文本内容，2：图片）
  final int    type;//消息类型（1：群组，2：1对1）

  MessageModel(
      {this.content,
      this.fromUserName,
      this.toUserName,
      this.type,
      this.messageType,
      this.id});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return new MessageModel(
      content: json['content'],
      id: json["id"],
      messageType: json["messageType"],
      fromUserName: json['fromUserName'],
      toUserName: json['toUserName'],
      type: json['type'],
    );
  }
}
