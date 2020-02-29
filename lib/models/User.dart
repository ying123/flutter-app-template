import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';

@JsonSerializable()
class User extends Object {

  @JsonKey(name: 'tenantId')
  int tenantId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'number')
  String number;

  @JsonKey(name: 'surname')
  String surname;

  @JsonKey(name: 'userName')
  String userName;

  @JsonKey(name: 'fullName')
  String fullName;

  @JsonKey(name: 'nickName')
  String nickName;

  @JsonKey(name: 'emailAddress')
  String emailAddress;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'id')
  int id;

  User(this.tenantId,this.name,this.number,this.surname,this.userName,this.fullName,this.nickName,this.emailAddress,this.avatar,this.id,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}


