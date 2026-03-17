import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/citizen/request/update_case_status_request.dart';
import '../models/citizen/response/update_case_status_response.dart';

class UpdateAlertStatusRepository {
  final Dio _dio = ApiService.dio;

  Future<UpdateAlertStatusResponse> updateAlertStatus(
    String alertId,
    UpdateAlertStatusRequest request,
  ) async {
    final response = await _dio.patch(
      "${ApiConstants.updateAlertStatus}/$alertId/status",
      data: request.toJson(),
      options: Options(
        extra: {'skipClientId': true},
      ),
    );

    return UpdateAlertStatusResponse.fromJson(response.data);
  }
}