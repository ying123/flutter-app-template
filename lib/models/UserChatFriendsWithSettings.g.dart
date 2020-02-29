// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserChatFriendsWithSettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChatFriendsWithSettings _$UserChatFriendsWithSettingsFromJson(
    Map<String, dynamic> json) {
  return UserChatFriendsWithSettings(
    json['serverTime'] as String,
    (json['friends'] as List)
        ?.map((e) =>
            e == null ? null : Friend.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserChatFriendsWithSettingsToJson(
        UserChatFriendsWithSettings instance) =>
    <String, dynamic>{
      'serverTime': instance.serverTime,
      'friends': instance.friends,
    };

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
    json['friendUserId'] as int,
    json['friendUser'] == null
        ? null
        : FriendUser.fromJson(json['friendUser'] as Map<String, dynamic>),
    json['friendTenantId'] as int,
    json['friendUserName'] as String,
    json['friendTenancyName'] as String,
    json['unreadMessageCount'] as int,
    json['isOnline'] as bool,
    json['state'] as int,
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'friendUserId': instance.friendUserId,
      'friendUser': instance.friendUser,
      'friendTenantId': instance.friendTenantId,
      'friendUserName': instance.friendUserName,
      'friendTenancyName': instance.friendTenancyName,
      'unreadMessageCount': instance.unreadMessageCount,
      'isOnline': instance.isOnline,
      'state': instance.state,
    };

FriendUser _$FriendUserFromJson(Map<String, dynamic> json) {
  return FriendUser(
    json['id'] as int,
    json['userName'] as String,
    json['nickName'] as String,
    json['avatar'] as String,
  );
}

Map<String, dynamic> _$FriendUserToJson(FriendUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'nickName': instance.nickName,
      'avatar': instance.avatar,
    };
