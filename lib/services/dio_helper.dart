import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
          print("Request [${options.method}] => PATH: ${options.path}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("Response [${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          print("Error [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}");
          print("Error Response: ${error.response?.data}");
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
    dynamic data,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    try {
      final requestOptions = options ?? Options();
      requestOptions.headers = {
        ...dio.options.headers, // Preserve existing global headers
        if (token != null) 'Authorization': 'Bearer $token',
      };

      return await dio.post(
        url,
        data: data,
        queryParameters: query,
        options: requestOptions,
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final responseData = e.response!.data as Map<String, dynamic>;
        if (responseData.containsKey('message')) {
          throw responseData['message'];
        } else if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          throw firstError is List ? firstError.first : firstError.toString();
        }
      }
      throw 'An error occurred while connecting to the server.';
    }
  }


  static void setToken(String? newToken) {
    token = newToken;
    dio.options.headers['Authorization'] = token != null ? 'Bearer $token' : null;
  }

  static void clearToken() {
    setToken(null);
  }
}


void handleApiError(DioError error, BuildContext context) {
  final errorData = error.response?.data;

  if (errorData is Map<String, dynamic>) {
    if (errorData.containsKey('errors')) {
      final errors = errorData['errors'] as Map<String, dynamic>;
      final errorMessage = errors.entries.map((entry) {
        final key = entry.key;
        final messages = (entry.value as List).join(", ");
        return "$key: $messages";
      }).join("\n");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Validation Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (errorData.containsKey('message')) {
      final message = errorData['message'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An unexpected error occurred.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to connect to the server.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
