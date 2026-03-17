class CompleteProfileResponse {
  bool? success;
  String? message;
  CompleteProfileData? data;

  CompleteProfileResponse({
    this.success,
    this.message,
    this.data,
  });

  CompleteProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? CompleteProfileData.fromJson(json['data'])
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

class CompleteProfileData {
  String? token;
  String? email;
  int? registrationStep;
  String? clientId;

  CompleteProfileData({
    this.token,
    this.email,
    this.registrationStep,
    this.clientId,
  });

  CompleteProfileData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
    registrationStep = json['registrationStep'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    data['email'] = email;
    data['registrationStep'] = registrationStep;
    data['clientId'] = clientId;
    return data;
  }
}