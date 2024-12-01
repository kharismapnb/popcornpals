import 'package:hive/hive.dart';

class DatabaseHelper {
  static const String userBox = 'userBox';

  Future<void> saveUser(String email, Map<String, dynamic> data) async {
    final box = Hive.box(userBox);
    box.put(email, data);
  }

  Map<String, dynamic>? getUser(String email) {
    final box = Hive.box(userBox);
    return box.get(email);
  }

  Future<void> deleteUser(String email) async {
    final box = Hive.box(userBox);
    box.delete(email);
  }
}
