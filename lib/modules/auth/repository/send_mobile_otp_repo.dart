import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/registration/requests/send_mobile_otp_request_model.dart';
import '../models/registration/responses/send_mobile_otp_response_model.dart';

class SendMobileOtpRepo {
  final _dio = ApiService.dio;
  Future<SendPhoneOtpResponse> sendmobileotp(SendPhoneOtpRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.sendMobileOtp,
      data: request.toJson(),
    );
    return SendPhoneOtpResponse.fromJson(response.data);
  }
}
