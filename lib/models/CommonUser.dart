import 'package:json_annotation/json_annotation.dart';
part 'CommonUser.g.dart';

@JsonSerializable()
class CommonUser extends Object {
  @JsonKey(name: 'number')
  String number;

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'say')
  String say;

  @JsonKey(name: 'nickName')
  String nickName;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'id')
  int id;

  CommonUser(this.say,this.number,this.cover,this.userName,this.nickName,this.avatar,this.id);

  factory CommonUser.fromJson(Map<String, dynamic> srcJson) => _$CommonUserFromJson(srcJson);
}


