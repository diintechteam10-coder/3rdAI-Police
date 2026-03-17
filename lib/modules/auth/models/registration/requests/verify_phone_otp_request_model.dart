class VerifyPhoneOtpRequestModel {
  final String email;
  final String phone;
  final String otp;
  final String clientId;

  VerifyPhoneOtpRequestModel({
    required this.email,
    required this.phone,
    required this.otp,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone": phone,
      "otp": otp,
      "clientId": clientId,
    };
  }

  factory VerifyPhoneOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyPhoneOtpRequestModel(
      email: json['email'],
      phone: json['phone'],
      otp: json['otp'],
      clientId: json['clientId'],
    );
  }
}