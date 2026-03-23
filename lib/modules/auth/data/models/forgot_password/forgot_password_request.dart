class ForgotPasswordRequest {
  final String email;
  final String clientId;

  ForgotPasswordRequest({
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
