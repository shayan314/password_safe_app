import 'package:encrypt/encrypt.dart';

class EncryptionService {

  // 32 length key (must be fixed)
  static final key =
    Key.fromUtf8('12345678901234567890123456789012');

  static final iv = IV.fromLength(16);

  static final encrypter = Encrypter(AES(key));

  // ENCRYPT
  static String encryptPassword(String password) {
    try {
      if (password.trim().isEmpty) {
        throw Exception("Empty password");
      }

      final encrypted =
      encrypter.encrypt(password.trim(), iv: iv);

      return encrypted.base64;

    } catch (e) {
      return "";
    }
  }

  // DECRYPT
  static String decryptPassword(String encryptedPassword) {
    try {
      if (encryptedPassword.isEmpty) return "Invalid Data";

      final decrypted =
      encrypter.decrypt64(encryptedPassword, iv: iv);

      return decrypted;

    } catch (e) {
      return "⚠️ Corrupted Data";
    }
  }
}