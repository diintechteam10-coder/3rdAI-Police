import 'package:dio/dio.dart';
import '../models/approval_status/approval_status_response_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';

class ApprovalStatusRepo {
  final _dio = ApiService.dio;

  Future<ApprovalStatusResponseModel> getApprovalStatus(String email) async {
    final response = await _dio.get(
      ApiConstants.approvalStatus,
      queryParameters: {'email': email},
      options: Options(extra: {"skipClientId": true}),
    );
    print("------------------------------------------");
    print("🚀 --- APPROVAL STATUS API RESPONSE --- 🚀");
    print("URL: ${ApiConstants.approvalStatus}");
    print("Email: $email");
    print("Response: ${response.data}");
    print("------------------------------------------");
    return ApprovalStatusResponseModel.fromJson(response.data);
  }
}
