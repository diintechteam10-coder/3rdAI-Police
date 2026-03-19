import 'package:thirdai/modules/auth/models/registration/requests/resend_email_otp_request_model.dart';
import 'package:thirdai/modules/auth/models/registration/requests/verify_email_otp_request.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/registration/responses/resend_email_otp_response_model.dart';
import '../models/registration/responses/verify_email_otp_response.dart';

class VerifyEmailOtpRepo {
  final _dio = ApiService.dio;

  Future<VerifyEmailOtpResponse> verifyemailOtp(
    VerifyOtpRequestModel request,
  ) async {
    final response = await _dio.post(
      ApiConstants.verifyEmailOtp,
      data: request.toJson(),
    );

    return VerifyEmailOtpResponse.fromJson(response.data);
  }

  Future<ResendEmailOtpResponseModel> resendEmailOtp(
    ResendEmailOtpRequestModel request,
  ) async {
    final response = await _dio.post(
      ApiConstants.resendEmailOtp,
      data: request.toJson(),
    );
    return ResendEmailOtpResponseModel.fromJson(response.data);
  }
}
