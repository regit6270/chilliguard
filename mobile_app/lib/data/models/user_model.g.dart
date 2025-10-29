// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      location: json['location'] == null
          ? null
          : UserLocationModel.fromJson(
              json['location'] as Map<String, dynamic>),
      fcmToken: json['fcm_token'] as String?,
      createdAt: UserModel._dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'location': instance.location,
      'fcm_token': instance.fcmToken,
      'created_at': UserModel._dateTimeToJson(instance.createdAt),
    };

UserLocationModel _$UserLocationModelFromJson(Map<String, dynamic> json) =>
    UserLocationModel(
      state: json['state'] as String,
      district: json['district'] as String,
      village: json['village'] as String?,
    );

Map<String, dynamic> _$UserLocationModelToJson(UserLocationModel instance) =>
    <String, dynamic>{
      'state': instance.state,
      'district': instance.district,
      'village': instance.village,
    };
