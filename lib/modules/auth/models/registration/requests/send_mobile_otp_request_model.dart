class SendPhoneOtpRequestModel {
  final String email;
  final String phone;
  final String otpMethod;
  final String clientId;

  SendPhoneOtpRequestModel({
    required this.email,
    required this.phone,
    required this.otpMethod,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "phone": phone,
      "otpMethod": otpMethod,
      "clientId": clientId,
    };
  }

  factory SendPhoneOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return SendPhoneOtpRequestModel(
      email: json['email'],
      phone: json['phone'],
      otpMethod: json['otpMethod'],
      clientId: json['clientId'],
    );
  }
}