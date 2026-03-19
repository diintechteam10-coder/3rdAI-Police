class ResendMobileOtpRequestModel {
  final String email;
  final String otpMethod;
  final String clientId;

  ResendMobileOtpRequestModel({
    required this.email,
    required this.otpMethod,
    required this.clientId,
  });

  // Convert Dart object → JSON
  Map<String, dynamic> toJson() {
    return {"email": email, "otpMethod": otpMethod, "clientId": clientId};
  }

  // Optional: fromJson (future flexibility)
  factory ResendMobileOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return ResendMobileOtpRequestModel(
      email: json['email'] ?? '',
      otpMethod: json['otpMethod'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }
}
