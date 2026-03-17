import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/citizen/response/alert_details_response.dart';

class GetPartnerAlertDetailsRepository {
  final Dio _dio = ApiService.dio;

  Future<AlertDetailsResponse> getAlertDetails(String alertId) async {
    final response = await _dio.get(
      "${ApiConstants.getAllAssignedCitizenAlerts}/$alertId",
      options: Options(
        extra: {'skipClientId': true},
      ),
    );

    return AlertDetailsResponse.fromJson(response.data);
  }
}