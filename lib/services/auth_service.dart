import 'package:dio/dio.dart';
import 'package:projectalpha/services/dio_helper.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Response response = await DioHelper.postData(
        url: 'login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String address,
    required int age,
    required String bloodType,
    required String gender,
  }) async {
    try {
      Response response = await DioHelper.postData(
        url: 'register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'address': address,
          'age': age,
          'blood_type': bloodType,
          'gender': gender,
        },
      );
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }
}