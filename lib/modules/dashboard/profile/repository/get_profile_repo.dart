import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/response/profile_response.dart';

class GetProfileRepository {
  final _dio = ApiService.dio;

  Future<PartnerProfileResponse> getProfile() async {
    final response = await _dio.get(
      ApiConstants.getProfile,
      options: Options(extra: {'skipClientId': true}),
    );

    return PartnerProfileResponse.fromJson(response.data);
  }

  Future<PartnerProfileResponse> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.patch(
      ApiConstants.getProfile,
      data: data,
      options: Options(extra: {'skipClientId': true}),
    );

    return PartnerProfileResponse.fromJson(response.data);
  }
}
