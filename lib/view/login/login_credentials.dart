import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginCredentials {
  static String email = '';
  static String password = '';
  static String passwordHash = '';  // Initializing with an empty string
  static String type = '';

  static void updatePassword(String newPassword) {
    password = newPassword;
    passwordHash = md5.convert(utf8.encode(password)).toString();  // Generate hash
  }
}
