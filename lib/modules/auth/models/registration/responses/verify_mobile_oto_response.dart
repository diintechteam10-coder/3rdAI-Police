class VerifyPhoneOtpResponse {
  bool? success;
  String? message;
  VerifyPhoneOtpData? data;

  VerifyPhoneOtpResponse({
    this.success,
    this.message,
    this.data,
  });

  VerifyPhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? VerifyPhoneOtpData.fromJson(json['data'])
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

class VerifyPhoneOtpData {
  String? email;
  bool? phoneVerified;
  String? clientId;

  VerifyPhoneOtpData({
    this.email,
    this.phoneVerified,
    this.clientId,
  });

  VerifyPhoneOtpData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phoneVerified = json['phoneVerified'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['phoneVerified'] = phoneVerified;
    data['clientId'] = clientId;
    return data;
  }
}