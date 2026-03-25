import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/camera/response/camera_response_model.dart';

class CameraRepository {
  final Dio _dio = ApiService.dio;
  static const String _cacheKey = 'cached_cameras_';

  Future<CameraResponse> getCameras({String? city, String? name}) async {
    final Map<String, dynamic> queryParameters = {};
    if (city != null && city.isNotEmpty) queryParameters['city'] = city;
    if (name != null && name.isNotEmpty) queryParameters['name'] = name;

    final response = await _dio.get(
      ApiConstants.getCameras,
      queryParameters: queryParameters,
      options: Options(
        extra: {'skipClientId': true},
      ),
    );

    final cameras = CameraResponse.fromJson(response.data);
    
    // Cache the response
    await _saveToCache(city, name, response.data);
    
    return cameras;
  }

  Future<CameraResponse?> getCachedCameras({String? city, String? name}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String key = '$_cacheKey${city}_${name}';
      final String? cachedData = prefs.getString(key);
      
      if (cachedData != null) {
        return CameraResponse.fromJson(jsonDecode(cachedData));
      }
    } catch (e) {
      print('Error reading cache: $e');
    }
    return null;
  }

  Future<void> _saveToCache(String? city, String? name, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String key = '$_cacheKey${city}_${name}';
      await prefs.setString(key, jsonEncode(data));
    } catch (e) {
      print('Error saving cache: $e');
    }
  }
}