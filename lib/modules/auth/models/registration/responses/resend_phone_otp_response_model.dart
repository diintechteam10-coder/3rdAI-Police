class ResendPhoneOtpResponseModel {
  final bool success;
  final String message;

  ResendPhoneOtpResponseModel({
    required this.success,
    required this.message,
  });
  factory ResendPhoneOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendPhoneOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }
}