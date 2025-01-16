import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../networking/constant.dart';

class DioHelper {
  static Dio? _dio;

  /// Get an instance of Dio
  static Future<Dio> getInstance() async {
    if (_dio == null) {
      // Base options for the Dio instance
      BaseOptions options = BaseOptions(
        baseUrl: baseURL, // Make sure `baseURL` is defined in your constants file
        connectTimeout: const Duration(seconds: 10), // Connection timeout
        receiveTimeout: const Duration(seconds: 10), // Response timeout
        headers: {
          'Content-Type': 'application/json', // Default headers
          'Accept': 'application/json',
        },
      );

      // Create the Dio instance
      _dio = Dio(options);

      // Add interceptors for logging and error handling
      _dio!.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
      ));

      // Add SSL bypass for development purposes
      (_dio!.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    return _dio!;
  }
}
