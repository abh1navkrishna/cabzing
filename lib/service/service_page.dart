import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class ServicePage {
  static Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('/api/v1/users/login', data: data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionError) {
        throw Exception(
            "Failed to connect to the server. Check your internet connection.");
      } else if (e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        throw Exception("Request timed out. Please try again.");
      } else if (e.response != null) {
        throw Exception(
            "Server error: ${e.response?.data['error'] ?? 'Unknown error'}");
      } else {
        throw Exception("Unexpected error: ${e.message}");
      }
    }
  }

  static Future getProfileDetails(int id) async {
    try {
      var dio = await DioHelper.getInstance();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      dio.options.headers['Authorization'] = 'Bearer $token';
      var response = await dio
          .get('https://www.api.viknbooks.com/api/v10/users/user-view/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
