class EmailCheckResponse {
  final bool success;
  final String message;
  final bool registrationComplete;
  final EmailCheckData data;

  EmailCheckResponse({
    required this.success,
    required this.message,
    required this.registrationComplete,
    required this.data,
  });

  factory EmailCheckResponse.fromJson(Map<String, dynamic> json) {
    return EmailCheckResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      registrationComplete: json['registrationComplete'] ?? false,
      data: EmailCheckData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "registrationComplete": registrationComplete,
      "data": data.toJson(),
    };
  }
}

class EmailCheckData {
  final String email;
  final bool emailVerified;
  final int registrationStep;
  final String nextStep;
  final String clientId;

  EmailCheckData({
    required this.email,
    required this.emailVerified,
    required this.registrationStep,
    required this.nextStep,
    required this.clientId,
  });

  factory EmailCheckData.fromJson(Map<String, dynamic> json) {
    return EmailCheckData(
      email: json['email'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      registrationStep: json['registrationStep'] ?? 0,
      nextStep: json['nextStep'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "emailVerified": emailVerified,
      "registrationStep": registrationStep,
      "nextStep": nextStep,
      "clientId": clientId,
    };
  }
}