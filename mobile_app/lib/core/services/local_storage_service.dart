import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

@lazySingleton
class LocalStorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  LocalStorageService(this._prefs)
      : _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  Future<void> init() async {
    // Initialization logic if needed
  }

  // Secure Token Storage
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: AppConstants.keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: AppConstants.keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.keyAccessToken);
    await _secureStorage.delete(key: AppConstants.keyRefreshToken);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.keyUserId, userId);
  }

  String? getUserId() {
    return _prefs.getString(AppConstants.keyUserId);
  }

  // Selected Field
  Future<void> saveSelectedFieldId(String fieldId) async {
    await _prefs.setString(AppConstants.keySelectedFieldId, fieldId);
  }

  String? getSelectedFieldId() {
    return _prefs.getString(AppConstants.keySelectedFieldId);
  }

  // Language
  Future<void> saveLanguageCode(String languageCode) async {
    await _prefs.setString(AppConstants.keyLanguageCode, languageCode);
  }

  String getLanguageCode() {
    return _prefs.getString(AppConstants.keyLanguageCode) ?? 'hi';
  }

  // First Launch
  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(AppConstants.keyIsFirstLaunch, value);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }
}
