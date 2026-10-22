import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

/// Manages application-wide theme mode (light / dark).
/// Persists the preference in SharedPreferences and restores it on startup.
final class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(mode: ThemeMode.dark));

  static const String _prefKey = 'theme_mode';

  /// Call once during app initialization to restore persisted preference.
  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == 'light') {
      emit(const ThemeState(mode: ThemeMode.light));
    } else {
      emit(const ThemeState(mode: ThemeMode.dark));
    }
  }

  /// Toggle between light and dark modes.
  Future<void> toggleTheme() async {
    final newMode =
        state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(mode: newMode));
    await _persist(newMode);
  }

  /// Explicitly set a specific theme mode.
  Future<void> setTheme(ThemeMode mode) async {
    if (state.mode == mode) return;
    emit(state.copyWith(mode: mode));
    await _persist(mode);
  }

  Future<void> _persist(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, mode == ThemeMode.light ? 'light' : 'dark');
  }
}
