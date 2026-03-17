class SendEmailOtpRequestModel {
  final String email;
  final String clientId;

  SendEmailOtpRequestModel({
    required this.email,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "clientId": clientId,
    };
  }

  factory SendEmailOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return SendEmailOtpRequestModel(
      email: json['email'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }

  SendEmailOtpRequestModel copyWith({
    String? email,
    String? clientId,
  }) {
    return SendEmailOtpRequestModel(
      email: email ?? this.email,
      clientId: clientId ?? this.clientId,
    );
  }
}