import 'package:dio/dio.dart';
import 'package:projectalpha/services/constants.dart';

class DioHelper {
  static late Dio dio;
  static String? token;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseURL,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          print("Error: ${error.response?.statusCode} ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? customToken,
  }) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer ${customToken ?? token}';
      return await dio.get(url, queryParameters: query);
    } catch (error) {
      rethrow;
    }
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? customToken,
  }) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer ${customToken ?? token}';
      return await dio.post(url, queryParameters: query, data: data);
    } catch (error) {
      rethrow;
    }
  }

  static void setToken(String? newToken) {
    token = newToken;
  }

  static void clearToken() {
    token = null;
  }
}
