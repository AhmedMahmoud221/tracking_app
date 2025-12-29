import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final isDark = await SecureStorage.readTheme();
    emit(isDark ? ThemeState.dark : ThemeState.light);
  }

  Future<void> toggleTheme(bool isDark) async {
    await SecureStorage.saveTheme(isDark);
    emit(isDark ? ThemeState.dark : ThemeState.light);
  }

  ThemeMode get themeMode =>
      state == ThemeState.dark ? ThemeMode.dark : ThemeMode.light;
}
