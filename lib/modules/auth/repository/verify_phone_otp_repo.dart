import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/registration/requests/verify_phone_otp_request_model.dart';
import '../models/registration/responses/verify_mobile_oto_response.dart';

class VerifyPhoneOtpRepo {
  final _dio = ApiService.dio;

  Future<VerifyPhoneOtpResponse> verifyphoneOtp(
      VerifyPhoneOtpRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.verifyMobileOtp,
      data: request.toJson(),
    );

    return VerifyPhoneOtpResponse.fromJson(response.data);
  }
}