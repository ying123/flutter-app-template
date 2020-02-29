import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';
part 'UserChatFriendsWithSettings.g.dart';


@JsonSerializable()
class UserChatFriendsWithSettings extends Object {

  @JsonKey(name: 'serverTime')
  String serverTime;

  @JsonKey(name: 'friends')
  List<Friend> friends;

  UserChatFriendsWithSettings(this.serverTime,this.friends,);

  factory UserChatFriendsWithSettings.fromJson(Map<String, dynamic> srcJson) => _$UserChatFriendsWithSettingsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserChatFriendsWithSettingsToJson(this);

}


@JsonSerializable()
class Friend extends ISuspensionBean {
  String tagIndex;
  String namePinyin;

  @override
  String getSuspensionTag() => tagIndex;

  @JsonKey(name: 'friendUserId')
  int friendUserId;

  @JsonKey(name: 'friendUser')
  FriendUser friendUser;

  @JsonKey(name: 'friendTenantId')
  int friendTenantId;

  @JsonKey(name: 'friendUserName')
  String friendUserName;

  @JsonKey(name: 'friendTenancyName')
  String friendTenancyName;

  @JsonKey(name: 'unreadMessageCount')
  int unreadMessageCount;

  @JsonKey(name: 'isOnline')
  bool isOnline;

  @JsonKey(name: 'state')
  int state;

  get shownName {
    return friendUser.nickName ?? friendUser.userName;
  }

  Friend(this.friendUserId,this.friendUser,this.friendTenantId,this.friendUserName,this.friendTenancyName,this.unreadMessageCount,this.isOnline,this.state,);

  factory Friend.fromJson(Map<String, dynamic> srcJson) => _$FriendFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FriendToJson(this);

}


@JsonSerializable()
class FriendUser extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'nickName')
  String nickName;

  String get shownName {
    return this.nickName ?? this.userName;
  }

  @JsonKey(name: 'avatar')
  String avatar;

  FriendUser(this.id,this.userName,this.nickName,this.avatar,);

  factory FriendUser.fromJson(Map<String, dynamic> srcJson) => _$FriendUserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FriendUserToJson(this);

}


