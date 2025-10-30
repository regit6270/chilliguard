/// Simple user model for local storage (no code generation needed)
/// Uses Map serialization instead of Hive TypeAdapter
class UserLocalModel {
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final String? profilePicture;
  final DateTime createdAt;
  final bool isLoggedIn;
  final String? fcmToken;

  // Farmer-specific location data
  final String? state;
  final String? district;
  final String? village;

  UserLocalModel({
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.profilePicture,
    required this.createdAt,
    this.isLoggedIn = false,
    this.fcmToken,
    this.state,
    this.district,
    this.village,
  });

  /// Convert to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'isLoggedIn': isLoggedIn,
      'fcmToken': fcmToken,
      'state': state,
      'district': district,
      'village': village,
    };
  }

  /// Create from Map (Hive retrieval)
  factory UserLocalModel.fromMap(Map<String, dynamic> map) {
    return UserLocalModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String?,
      profilePicture: map['profilePicture'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isLoggedIn: map['isLoggedIn'] as bool? ?? false,
      fcmToken: map['fcmToken'] as String?,
      state: map['state'] as String?,
      district: map['district'] as String?,
      village: map['village'] as String?,
    );
  }

  /// Create from Firebase User
  factory UserLocalModel.fromFirebaseUser({
    required String uid,
    required String phoneNumber,
    String? displayName,
    String? email,
    String? photoURL,
  }) {
    return UserLocalModel(
      userId: uid,
      name: displayName ?? _extractNameFromPhone(phoneNumber) ?? 'User',
      phone: phoneNumber,
      email: email,
      profilePicture: photoURL,
      createdAt: DateTime.now(),
      isLoggedIn: true,
    );
  }

  /// Helper: Extract last 10 digits from phone number
  static String? _extractNameFromPhone(String phone) {
    if (phone.length >= 10) {
      return 'Farmer ${phone.substring(phone.length - 4)}'; // Last 4 digits
    }
    return null;
  }

  /// Create copy with modified fields
  UserLocalModel copyWith({
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? profilePicture,
    DateTime? createdAt,
    bool? isLoggedIn,
    String? fcmToken,
    String? state,
    String? district,
    String? village,
  }) {
    return UserLocalModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      fcmToken: fcmToken ?? this.fcmToken,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
    );
  }

  @override
  String toString() {
    return 'UserLocalModel(name: $name, phone: $phone, email: $email, loggedIn: $isLoggedIn)';
  }
}
