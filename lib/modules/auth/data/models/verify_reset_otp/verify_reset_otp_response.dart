class VerifyResetOtpResponse {
  final bool success;
  final String message;
  final VerifyResetOtpData? data;

  VerifyResetOtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyResetOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyResetOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyResetOtpData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class VerifyResetOtpData {
  final String resetToken;

  VerifyResetOtpData({required this.resetToken});

  factory VerifyResetOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyResetOtpData(
      resetToken: json['resetToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resetToken': resetToken,
    };
  }
}
