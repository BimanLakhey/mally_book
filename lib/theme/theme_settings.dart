import 'package:flutter/material.dart';

import '../configs/app_config.dart';

class ThemeSettings with ChangeNotifier {
  static bool _isDark = false;

  ThemeSettings() {
    if(prefs.containsKey("enableDarkTheme")) {
      _isDark = prefs.getBool("enableDarkTheme")!;
    } else {
      prefs.setBool("enableDarkTheme", _isDark);
    }
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    prefs.setBool("enableDarkTheme", _isDark);
    notifyListeners();
  }
}