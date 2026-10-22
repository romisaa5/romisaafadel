import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_state.dart';

/// Manages application-wide locale (en / ar).
/// English is the default. Persists the preference in SharedPreferences.
final class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(locale: Locale('en')));

  static const String _prefKey = 'locale_code';

  static const Locale _english = Locale('en');
  static const Locale _arabic = Locale('ar');

  /// Call once during app initialization to restore persisted locale.
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == 'ar') {
      emit(const LocaleState(locale: _arabic));
    } else {
      emit(const LocaleState(locale: _english));
    }
  }

  /// Switch to Arabic locale.
  Future<void> setArabic() async {
    if (state.isArabic) return;
    emit(const LocaleState(locale: _arabic));
    await _persist('ar');
  }

  /// Switch to English locale.
  Future<void> setEnglish() async {
    if (state.isEnglish) return;
    emit(const LocaleState(locale: _english));
    await _persist('en');
  }

  /// Toggle between English and Arabic.
  Future<void> toggleLocale() async {
    if (state.isArabic) {
      await setEnglish();
    } else {
      await setArabic();
    }
  }

  Future<void> _persist(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, code);
  }
}
