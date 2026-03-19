class ResendEmailOtpResponseModel {
  final bool success;
  final String message;

  ResendEmailOtpResponseModel({
    required this.success,
    required this.message,
  });
  factory ResendEmailOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendEmailOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // Optional: toJson (agar kahin use karna ho)
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }
}