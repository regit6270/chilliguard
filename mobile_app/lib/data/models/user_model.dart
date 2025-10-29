import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id')
  final String userId;

  final String name;
  final String phone;
  final String? email;
  final UserLocationModel? location;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  const UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.location,
    this.fcmToken,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      userId: userId,
      name: name,
      phone: phone,
      email: email,
      location: location?.toEntity(),
      fcmToken: fcmToken,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      location: entity.location != null
          ? UserLocationModel.fromEntity(entity.location!)
          : null,
      fcmToken: entity.fcmToken,
      createdAt: entity.createdAt,
    );
  }

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();
}

@JsonSerializable()
class UserLocationModel {
  final String state;
  final String district;
  final String? village;

  const UserLocationModel({
    required this.state,
    required this.district,
    this.village,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationModelToJson(this);

  UserLocation toEntity() {
    return UserLocation(
      state: state,
      district: district,
      village: village,
    );
  }

  factory UserLocationModel.fromEntity(UserLocation entity) {
    return UserLocationModel(
      state: entity.state,
      district: entity.district,
      village: entity.village,
    );
  }
}
