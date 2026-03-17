import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/citizen/response/all_assigned_citizen_alerts.dart';

class GetAlertsRepository {
  final _dio = ApiService.dio;

  Future<AlertsResponseModel> getAlerts({
    String type = "USER",
    int limit = 50,
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiConstants.getAllAssignedCitizenAlerts,
      queryParameters: {
        "type": type,
        "limit": limit,
        "page": page,
      },
      options: Options(extra: {'skipClientId': true}),
    );

    return AlertsResponseModel.fromJson(response.data);
  }

  Future<bool> updateAlertStatus({
    required String alertId,
    required String status,
    required String basisType,
    String? note,
  }) async {
    try {
      final response = await _dio.patch(
        "${ApiConstants.getAllAssignedCitizenAlerts}/$alertId",
        data: {
          "status": status,
          "basisType": basisType,
          "note": note ?? "Status updated by partner",
        },
        options: Options(extra: {'skipClientId': true}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error updating alert status: $e");
      return false;
    }
  }
}