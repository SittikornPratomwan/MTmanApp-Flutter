import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global Theme Manager with SharedPreferences
class AppTheme {
  static bool _isDarkMode = false;
  static final List<VoidCallback> _listeners = [];
  static bool _initialized = false;
  static const String _darkModeKey = 'isDarkMode';
  
  static bool get isDarkMode => _isDarkMode;
  
  // Initialize theme from saved preferences
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      _initialized = true;
      
      print('Theme initialized: Dark mode = $_isDarkMode');
      
      // Notify listeners after initialization
      _notifyListeners();
    } catch (e) {
      print('Error initializing theme: $e');
      _isDarkMode = false;
      _initialized = true;
    }
  }
  
  static Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    
    try {
      _isDarkMode = value;
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, value);
      
      print('Theme saved: Dark mode = $value');
      
      // Notify all listeners
      _notifyListeners();
    } catch (e) {
      print('Error saving theme: $e');
      // Revert if save failed
      _isDarkMode = !value;
    }
  }
  
  static void _notifyListeners() {
    for (var listener in _listeners) {
      try {
        listener();
      } catch (e) {
        print('Error notifying theme listener: $e');
      }
    }
  }
  
  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  static Future<void> toggleTheme() async {
    await setDarkMode(!_isDarkMode);
  }
  
  // Helper methods for common theme colors
  static Color primaryColor(BuildContext context) {
    return _isDarkMode 
        ? Colors.lightBlueAccent 
        : Theme.of(context).primaryColor;
  }
  
  static Color backgroundColor(BuildContext context) {
    return _isDarkMode 
        ? const Color(0xFF121212) 
        : Theme.of(context).scaffoldBackgroundColor;
  }
  
  static Color cardColor(BuildContext context) {
    return _isDarkMode 
        ? const Color(0xFF232526) 
        : Theme.of(context).cardColor;
  }
  
  static Color textColor(BuildContext context) {
    return _isDarkMode 
        ? Colors.white 
        : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }
  
  static Color subtitleColor(BuildContext context) {
    return _isDarkMode 
        ? Colors.white70 
        : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54;
  }
}
