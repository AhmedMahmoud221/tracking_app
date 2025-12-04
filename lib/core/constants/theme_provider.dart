import 'package:flutter/material.dart';

class ThemeProvider {
 // ValueNotifier to hold the current theme mode
  static ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  static void toggleTheme() {
    if (themeNotifier.value == ThemeMode.light) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }
}
