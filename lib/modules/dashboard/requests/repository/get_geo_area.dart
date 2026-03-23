import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/area/response/geo_area_response.dart';

class GetGeoAreaRepository {
  final Dio _dio = ApiService.dio;

  Future<GeoJsonResponse> getGeoArea() async {
    final response = await _dio.get(
      ApiConstants.getGeoArea,
      options: Options(
        extra: {'skipClientId': true},
      ),
    );
    return GeoJsonResponse.fromJson(response.data);
  }
}