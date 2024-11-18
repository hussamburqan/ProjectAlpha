import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static late Box box;

  static Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox('userBox');
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await box.put('token', userData['data']['token']);
    await box.put('user', userData['data']['user']);
  }

  static Future<void> clearUserData() async {
    await box.clear();
  }
}
