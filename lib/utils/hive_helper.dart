import 'package:hive/hive.dart';

class HiveHelper {
  static final Box _userBox = Hive.box('users');

  static void addUser(String username, String email, String password) {
    _userBox.put(username, {'email': email, 'password': password});
  }

  static Map<String, dynamic>? getUser(String username) {
    return _userBox.get(username);
  }

  static void updatePassword(String username, String newPassword) {
    final user = _userBox.get(username);
    if (user != null) {
      _userBox.put(username, {'email': user['email'], 'password': newPassword});
    }
  }

  static bool usernameExists(String username) {
    return _userBox.containsKey(username);
  }
}
