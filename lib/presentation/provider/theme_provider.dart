import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  late Box _settingsBox;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    _settingsBox = Hive.box('settings');
    _isDarkMode = _settingsBox.get(_themeKey, defaultValue: false);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _settingsBox.put(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
