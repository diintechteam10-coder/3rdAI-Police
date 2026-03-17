import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/registration/requests/send_email_otp_request_model.dart';
import '../models/registration/responses/send_email_otp_response_model.dart';

class SendEmailOtpRepository {
  final _dio = ApiService.dio;
  Future<OtpResponse> sendemailOtp(SendEmailOtpRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.sendEmialOtp,
      data: request.toJson(),
    );
    return OtpResponse.fromJson(response.data);
  }
}
