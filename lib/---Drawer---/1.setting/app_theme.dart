import 'package:flutter/material.dart';

class AppTheme {
  static bool _isDarkMode = false;
  static final List<VoidCallback> _listeners = [];

  static bool get isDarkMode => _isDarkMode;

  static void setDarkMode(bool value) {
    _isDarkMode = value;
    _notifyListeners();
  }

  static void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _notifyListeners();
  }

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}
