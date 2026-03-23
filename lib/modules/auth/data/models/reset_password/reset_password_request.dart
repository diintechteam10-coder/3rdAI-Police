class ResetPasswordRequest {
  final String email;
  final String resetToken;
  final String newPassword;
  final String clientId;

  ResetPasswordRequest({
    required this.email,
    required this.resetToken,
    required this.newPassword,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'resetToken': resetToken,
      'newPassword': newPassword,
      'clientId': clientId,
    };
  }
}
