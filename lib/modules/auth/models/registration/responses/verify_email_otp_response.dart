class VerifyEmailOtpResponse {
  bool? success;
  String? message;
  Data? data;

  VerifyEmailOtpResponse({this.success, this.message, this.data});

  VerifyEmailOtpResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? email;
  bool? emailVerified;
  String? clientId;

  Data({this.email, this.emailVerified, this.clientId});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailVerified = json['emailVerified'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['emailVerified'] = emailVerified;
    data['clientId'] = clientId;
    return data;
  }
}