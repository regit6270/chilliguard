import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/user_local_model.dart';
import '../utils/app_logger.dart';

@lazySingleton
class UserService {
  static const String _userBoxName = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _settingsBoxName = 'settings';

  Box get _userBox => Hive.box(_userBoxName);
  Box get _settingsBox => Hive.box(_settingsBoxName);

  // ========================================
  // USER MANAGEMENT
  // ========================================

  /// Save user from Firebase Auth
  Future<void> saveUserFromFirebase(User firebaseUser) async {
    try {
      final user = UserLocalModel.fromFirebaseUser(
        uid: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber ?? '',
        displayName: firebaseUser.displayName,
        email: firebaseUser.email,
        photoURL: firebaseUser.photoURL,
      );

      await _userBox.put(_currentUserKey, user.toMap());
      AppLogger.info(
          '✅ User saved to local storage: ${user.name} (${user.phone})');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save user from Firebase', e, stackTrace);
    }
  }

  /// Save custom user
  Future<void> saveUser(UserLocalModel user) async {
    try {
      await _userBox.put(_currentUserKey, user.toMap());
      AppLogger.info('✅ User saved to local storage: ${user.name}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save user', e, stackTrace);
    }
  }

  /// Get current user
  UserLocalModel? getCurrentUser() {
    try {
      final map = _userBox.get(_currentUserKey);
      if (map == null) {
        AppLogger.info('ℹ️ No user found in local storage');
        return null;
      }

      final user =
          UserLocalModel.fromMap(Map<String, dynamic>.from(map as Map));
      AppLogger.info('📱 Retrieved user: ${user.name} (${user.phone})');
      return user;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get current user', e, stackTrace);
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final user = getCurrentUser();
    final loggedIn = user != null && user.isLoggedIn;
    AppLogger.info('🔐 Login status check: $loggedIn');
    return loggedIn;
  }

  /// Update user profile
  Future<void> updateUser({
    String? name,
    String? email,
    String? profilePicture,
    String? state,
    String? district,
    String? village,
  }) async {
    final user = getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        name: name,
        email: email,
        profilePicture: profilePicture,
        state: state,
        district: district,
        village: village,
      );

      await saveUser(updatedUser);
      AppLogger.info('✅ User profile updated: ${updatedUser.name}');
    } else {
      AppLogger.warning('⚠️ Cannot update user - no user logged in');
    }
  }

  /// Logout (keeps user data but marks as logged out)
  Future<void> logout() async {
    final user = getCurrentUser();
    if (user != null) {
      final loggedOutUser = user.copyWith(isLoggedIn: false);
      await _userBox.put(_currentUserKey, loggedOutUser.toMap());
      AppLogger.info('🚪 User logged out: ${user.name}');
    } else {
      AppLogger.info('ℹ️ No user to logout');
    }
  }

  /// Clear all user data (complete logout)
  Future<void> clearAllData() async {
    try {
      await _userBox.clear();
      await _settingsBox.clear();
      AppLogger.info('🗑️ All user data and settings cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear data', e, stackTrace);
    }
  }

  // ========================================
  // SETTINGS & PREFERENCES (For Farmers)
  // ========================================

  /// Get language preference (Hindi by default for farmers)
  String getLanguage() {
    return _settingsBox.get('language', defaultValue: 'hi');
  }

  /// Set language preference
  Future<void> setLanguage(String languageCode) async {
    await _settingsBox.put('language', languageCode);
    AppLogger.info('🌐 Language preference set to: $languageCode');
  }

  /// Check if onboarding completed
  bool hasCompletedOnboarding() {
    return _settingsBox.get('onboarding_done', defaultValue: false);
  }

  /// Mark onboarding complete
  Future<void> markOnboardingComplete() async {
    await _settingsBox.put('onboarding_done', true);
    AppLogger.info('✅ Onboarding marked as complete');
  }

  /// Get user region (for localized farming tips)
  String getUserRegion() {
    final user = getCurrentUser();
    if (user?.state != null && user?.district != null) {
      return '${user!.district}, ${user.state}';
    }
    return 'India'; // Default region
  }

  /// Store last sync time (for offline data)
  Future<void> updateLastSyncTime() async {
    await _settingsBox.put('last_sync', DateTime.now().toIso8601String());
    AppLogger.info('🔄 Last sync time updated');
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    final syncTime = _settingsBox.get('last_sync');
    if (syncTime != null) {
      return DateTime.parse(syncTime as String);
    }
    return null;
  }

  // ========================================
  // DEBUGGING HELPERS
  // ========================================

  /// Print all stored data (for debugging)
  void debugPrintStorage() {
    AppLogger.info('=== USER STORAGE DEBUG ===');
    AppLogger.info('User box keys: ${_userBox.keys.toList()}');
    AppLogger.info('Settings box keys: ${_settingsBox.keys.toList()}');

    final user = getCurrentUser();
    if (user != null) {
      AppLogger.info('Current user: ${user.toString()}');
    } else {
      AppLogger.info('No current user');
    }
    AppLogger.info('========================');
  }
}
