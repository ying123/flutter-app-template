// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['tenantId'] as int,
    json['name'] as String,
    json['number'] as String,
    json['surname'] as String,
    json['userName'] as String,
    json['fullName'] as String,
    json['nickName'] as String,
    json['emailAddress'] as String,
    json['avatar'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'tenantId': instance.tenantId,
      'name': instance.name,
      'number': instance.number,
      'surname': instance.surname,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'nickName': instance.nickName,
      'emailAddress': instance.emailAddress,
      'avatar': instance.avatar,
      'id': instance.id,
    };
