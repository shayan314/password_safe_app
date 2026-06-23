import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const String _key = "user_pin";

  // SAVE PIN
  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, pin);
  }

  // GET PIN
  static Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  // CHECK IF PIN EXISTS
  static Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }

  // VERIFY PIN
  static Future<bool> verifyPin(String pin) async {
    final savedPin = await getPin();
    return savedPin == pin;
  }

  // RESET PIN (for forgot password later)
  static Future<void> resetPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}