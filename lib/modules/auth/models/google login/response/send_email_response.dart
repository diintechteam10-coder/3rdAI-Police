class GoogleSignInResponse {
  final bool success;
  final String message;
  final bool registrationComplete;
  final GoogleData data;

  GoogleSignInResponse({
    required this.success,
    required this.message,
    required this.registrationComplete,
    required this.data,
  });

  factory GoogleSignInResponse.fromJson(Map<String, dynamic> json) {
    return GoogleSignInResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      registrationComplete: json['registrationComplete'] ?? false,
      data: GoogleData.fromJson(json['data'] ?? {}),
    );
  }
}
class GoogleData {
  final String? token;
  final String? email;
  final String? clientId;

  final bool? emailVerified;
  final int? registrationStep;
  final String? nextStep;

  GoogleData({
    this.token,
    this.email,
    this.clientId,
    this.emailVerified,
    this.registrationStep,
    this.nextStep,
  });

  factory GoogleData.fromJson(Map<String, dynamic> json) {
    return GoogleData(
      token: json['token'], // only in login case
      email: json['email'],
      clientId: json['clientId'],
      emailVerified: json['emailVerified'],
      registrationStep: json['registrationStep'],
      nextStep: json['nextStep'],
    );
  }

  /// 🔥 Helper methods (VERY USEFUL)
  bool get isLoggedIn => token != null;
  bool get isRegistrationFlow => token == null;
}