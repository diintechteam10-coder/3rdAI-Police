class ResendResetOtpResponse {
  final bool success;
  final String message;

  ResendResetOtpResponse({
    required this.success,
    required this.message,
  });

  factory ResendResetOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendResetOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
