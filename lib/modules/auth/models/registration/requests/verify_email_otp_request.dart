class VerifyOtpRequestModel {
  final String email;
  final String otp;
  final String clientId;

  VerifyOtpRequestModel({
    required this.email,
    required this.otp,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
      "clientId": clientId,
    };
  }
}