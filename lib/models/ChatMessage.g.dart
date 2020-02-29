// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMessage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
    userId: json['userId'] as int,
    tenantId: json['tenantId'] as int,
    targetUserId: json['targetUserId'] as int,
    targetTenantId: json['targetTenantId'] as int,
    contentType:
        _$enumDecodeNullable(_$MessageContentTypeEnumMap, json['contentType']),
    content: json['content'] as String,
    thumbPath: json['thumbPath'] as String,
    url: json['url'] as String,
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    type: _$enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
    creationTime: json['creationTime'] == null
        ? null
        : DateTime.parse(json['creationTime'] as String),
    side: _$enumDecodeNullable(_$ChatSideEnumMap, json['side']),
    readState:
        _$enumDecodeNullable(_$ChatMessageReadStateEnumMap, json['readState']),
    receiverReadState: _$enumDecodeNullable(
        _$ChatMessageReadStateEnumMap, json['receiverReadState']),
    id: json['id'] as int,
    sharedMessageId: json['sharedMessageId'] as String,
  )
    ..status = _$enumDecodeNullable(_$MessageStatusEnumMap, json['status'])
    ..length = json['length'] as int
    ..isVoicePlaying = json['isVoicePlaying'] as bool;
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'tenantId': instance.tenantId,
      'targetUserId': instance.targetUserId,
      'targetTenantId': instance.targetTenantId,
      'contentType': _$MessageContentTypeEnumMap[instance.contentType],
      'status': _$MessageStatusEnumMap[instance.status],
      'content': instance.content,
      'length': instance.length,
      'isVoicePlaying': instance.isVoicePlaying,
      'thumbPath': instance.thumbPath,
      'url': instance.url,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': _$MessageTypeEnumMap[instance.type],
      'creationTime': instance.creationTime?.toIso8601String(),
      'side': _$ChatSideEnumMap[instance.side],
      'readState': _$ChatMessageReadStateEnumMap[instance.readState],
      'receiverReadState': _$ChatMessageReadStateEnumMap[instance.receiverReadState],
      'id': instance.id,
      'sharedMessageId': instance.sharedMessageId,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: ''${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: ''${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MessageContentTypeEnumMap = {
  MessageContentType.Text: 0,
  MessageContentType.Image: 1,
  MessageContentType.Video: 2,
  MessageContentType.Audio: 3,
  MessageContentType.Location: 4,
};

const _$MessageTypeEnumMap = {
  MessageType.Chat: 0,
  MessageType.Group: 1,
};

const _$ChatSideEnumMap = {
  ChatSide.UnKnow: 0,
  ChatSide.Sender: 1,
  ChatSide.Receiver: 2,
};

const _$ChatMessageReadStateEnumMap = {
  ChatMessageReadState.UnKnow: 0,
  ChatMessageReadState.Unread: 1,
  ChatMessageReadState.Read: 2,
};

const _$MessageStatusEnumMap = {
  MessageStatus.Ready: 0,
  MessageStatus.Sending: 1,
};
