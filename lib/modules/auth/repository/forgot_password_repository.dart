import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../data/models/forgot_password/forgot_password_request.dart';
import '../data/models/forgot_password/forgot_password_response.dart';
import '../data/models/verify_reset_otp/verify_reset_otp_request.dart';
import '../data/models/verify_reset_otp/verify_reset_otp_response.dart';
import '../data/models/reset_password/reset_password_request.dart';
import '../data/models/reset_password/reset_password_response.dart';
import '../data/models/resend_reset_otp/resend_reset_otp_request.dart';
import '../data/models/resend_reset_otp/resend_reset_otp_response.dart';

class ForgotPasswordRepository {
  final _dio = ApiService.dio;

  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest request) async {
    final response = await _dio.post(
      ApiConstants.forgotPassword,
      data: request.toJson(),
      options: Options(extra: {"skipClientId": true}),
    );
    return ForgotPasswordResponse.fromJson(response.data);
  }

  Future<VerifyResetOtpResponse> verifyResetOtp(VerifyResetOtpRequest request) async {
    final response = await _dio.post(
      ApiConstants.verifyResetOtp,
      data: request.toJson(),
      options: Options(extra: {"skipClientId": true}),
    );
    return VerifyResetOtpResponse.fromJson(response.data);
  }

  Future<ResetPasswordResponse> resetPassword(ResetPasswordRequest request) async {
    final response = await _dio.post(
      ApiConstants.resetPassword,
      data: request.toJson(),
      options: Options(extra: {"skipClientId": true}),
    );
    return ResetPasswordResponse.fromJson(response.data);
  }

  Future<ResendResetOtpResponse> resendResetOtp(ResendResetOtpRequest request) async {
    final response = await _dio.post(
      ApiConstants.resendResetOtp,
      data: request.toJson(),
      options: Options(extra: {"skipClientId": true}),
    );
    return ResendResetOtpResponse.fromJson(response.data);
  }
}
