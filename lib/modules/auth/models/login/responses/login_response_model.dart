class LoginResponseModel {
  bool? success;
  String? message;
  LoginData? data;

  LoginResponseModel({
    this.success,
    this.message,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? LoginData.fromJson(json['data'])
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

class LoginData {
  Partner? partner;
  String? token;

  LoginData({this.partner, this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    partner =
        json['partner'] != null ? Partner.fromJson(json['partner']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (partner != null) {
      data['partner'] = partner!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class Partner {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? profilePicture;
  bool? isVerified;
  String? verificationStatus;

  Partner({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePicture,
    this.isVerified,
    this.verificationStatus,
  });

  Partner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'];
    isVerified = json['isVerified'];
    verificationStatus = json['verificationStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['profilePicture'] = profilePicture;
    data['isVerified'] = isVerified;
    data['verificationStatus'] = verificationStatus;
    return data;
  }
}