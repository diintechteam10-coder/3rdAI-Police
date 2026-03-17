import 'package:thirdai/modules/auth/models/registration/requests/verify_email_otp_request.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/registration/responses/verify_email_otp_response.dart';

class VerifyEmailOtpRepo {
  final _dio = ApiService.dio;

  Future<VerifyEmailOtpResponse> verifyemailOtp(
      VerifyOtpRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.verifyEmailOtp,
      data: request.toJson(),
    );

    return VerifyEmailOtpResponse.fromJson(response.data);
  }
}