class ResendResetOtpRequest {
  final String email;
  final String clientId;

  ResendResetOtpRequest({
    required this.email,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'clientId': clientId,
    };
  }
}
