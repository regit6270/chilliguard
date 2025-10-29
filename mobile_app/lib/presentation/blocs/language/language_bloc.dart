import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart'; // ADD THIS
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_logger.dart';
import 'language_event.dart';
import 'language_state.dart';

@injectable // ADD THIS
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences _prefs;
  static const String _languageKey = 'app_language';

  LanguageBloc(this._prefs) : super(LanguageInitial()) {
    on<LanguageLoadRequested>(_onLanguageLoadRequested);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLanguageLoadRequested(
    LanguageLoadRequested event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      final languageCode = _prefs.getString(_languageKey) ?? 'en';
      emit(LanguageLoaded(Locale(languageCode)));
      AppLogger.info('Language loaded: $languageCode');
    } catch (e) {
      AppLogger.error('Failed to load language', e);
      emit(const LanguageLoaded(Locale('en')));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      await _prefs.setString(_languageKey, event.languageCode);
      emit(LanguageLoaded(Locale(event.languageCode)));
      AppLogger.info('Language changed to: ${event.languageCode}');
    } catch (e) {
      AppLogger.error('Failed to change language', e);
      emit(const LanguageError('Failed to change language'));
    }
  }
}
