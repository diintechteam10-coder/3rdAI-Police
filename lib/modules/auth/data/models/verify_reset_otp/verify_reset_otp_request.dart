class VerifyResetOtpRequest {
  final String email;
  final String otp;
  final String clientId;

  VerifyResetOtpRequest({
    required this.email,
    required this.otp,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'clientId': clientId,
    };
  }
}
