class SendPhoneOtpResponse {
  bool? success;
  String? message;
  PhoneOtpData? data;

  SendPhoneOtpResponse({
    this.success,
    this.message,
    this.data,
  });

  SendPhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? PhoneOtpData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.toJson();
    }

    return dataMap;
  }
}

class PhoneOtpData {
  String? email;
  String? phone;
  String? otpMethod;
  String? clientId;

  PhoneOtpData({
    this.email,
    this.phone,
    this.otpMethod,
    this.clientId,
  });

  PhoneOtpData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    otpMethod = json['otpMethod'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['phone'] = phone;
    data['otpMethod'] = otpMethod;
    data['clientId'] = clientId;
    return data;
  }
}