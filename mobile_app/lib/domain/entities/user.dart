import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final UserLocation? location;
  final String? fcmToken;
  final DateTime createdAt;

  const User({
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.location,
    this.fcmToken,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        phone,
        email,
        location,
        fcmToken,
        createdAt,
      ];
}

class UserLocation extends Equatable {
  final String state;
  final String district;
  final String? village;

  const UserLocation({
    required this.state,
    required this.district,
    this.village,
  });

  @override
  List<Object?> get props => [state, district, village];
}
