class ResendEmailOtpRequestModel {
  final String email;
  final String clientId;

  ResendEmailOtpRequestModel({
    required this.email,
    required this.clientId,
  });

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "clientId": clientId,
    };
  }

  // Optional: fromJson (agar kabhi use ho)
  factory ResendEmailOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return ResendEmailOtpRequestModel(
      email: json['email'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }
}