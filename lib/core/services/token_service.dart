import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveSession({
    required String token,
    required String userId,
    required String name,
    required String email,
    required String role,
      String? photo,
  }) async {
    await _prefs.setString('token', token);
    await _prefs.setString('user_id', userId);
    await _prefs.setString('user_name', name);
    await _prefs.setString('user_email', email);
    await _prefs.setString('user_role', role);
    if (photo != null) {
      await _prefs.setString('user_photo', photo);
    }
  }

  static String? getToken()     => _prefs.getString('token');
  static String? getUserName()  => _prefs.getString('user_name');
  static String? getUserEmail() => _prefs.getString('user_email');
  static String? getUserRole()  => _prefs.getString('user_role');
  static String? getUserPhoto() => _prefs.getString('user_photo');
  static bool    isLoggedIn()   => getToken() != null;

  static Future<void> clearSession() async {
    await _prefs.clear();
  }
}