import 'dart:io';

class AppConstants {
  static String baseURL = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/'
      : 'http://127.0.0.1:8000/api/';
  static String baseURLPhoto = Platform.isAndroid
      ? 'http://10.0.2.2:8000/'
      : 'http://127.0.0.1:8000/';
}