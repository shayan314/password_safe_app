import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false; // ☀️ default light mode

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get theme => isDark ? darkTheme : lightTheme;

  // 🔄 Toggle theme
  void toggleTheme() {
    isDark = !isDark;
    _saveTheme();
    notifyListeners();
  }

  // 💾 SAVE THEME
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  // 📥 LOAD THEME
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false; // default light
    notifyListeners();
  }

  // 🌙 DARK THEME
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F0F1A),
    cardColor: const Color(0xFF1A1A2E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F0F1A),
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6C63FF),
    ),
  );

  // ☀️ LIGHT THEME (your palette)
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5DC),
    cardColor: const Color(0xFFF4A460),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFE35336),
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE35336),
      secondary: Color(0xFFA0522D),
    ),
  );
}