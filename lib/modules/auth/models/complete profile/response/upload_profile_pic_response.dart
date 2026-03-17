class UploadProfileImageResponseModel {
  bool? success;
  String? message;
  UploadProfileImageData? data;

  UploadProfileImageResponseModel({
    this.success,
    this.message,
    this.data,
  });

  UploadProfileImageResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? UploadProfileImageData.fromJson(json['data'])
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
class UploadProfileImageData {
  User? user;

  UploadProfileImageData({this.user});

  UploadProfileImageData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
class User {
  Profile? profile;
  LiveLocation? liveLocation;

  String? id;
  String? email;
  String? authMethod;
  String? approvalStatus;

  bool? emailVerified;
  bool? mobileVerified;
  bool? loginApproved;
  bool? isActive;

  int? registrationStep;

  String? clientId;
  String? createdAt;
  String? updatedAt;

  String? mobile;
  int? v;

  String? profileImage;
  String? profileImageUrl;
  String? role;

  User({
    this.profile,
    this.liveLocation,
    this.id,
    this.email,
    this.authMethod,
    this.approvalStatus,
    this.emailVerified,
    this.mobileVerified,
    this.registrationStep,
    this.loginApproved,
    this.isActive,
    this.clientId,
    this.createdAt,
    this.updatedAt,
    this.mobile,
    this.v,
    this.profileImage,
    this.profileImageUrl,
    this.role,
  });

  User.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;

    liveLocation = json['liveLocation'] != null
        ? LiveLocation.fromJson(json['liveLocation'])
        : null;

    id = json['_id'];
    email = json['email'];
    authMethod = json['authMethod'];
    approvalStatus = json['approvalStatus'];

    emailVerified = json['emailVerified'];
    mobileVerified = json['mobileVerified'];
    registrationStep = json['registrationStep'];

    loginApproved = json['loginApproved'];
    isActive = json['isActive'];

    clientId = json['clientId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    mobile = json['mobile'];
    v = json['__v'];

    profileImage = json['profileImage'];
    profileImageUrl = json['profileImageUrl'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (profile != null) {
      data['profile'] = profile!.toJson();
    }

    if (liveLocation != null) {
      data['liveLocation'] = liveLocation!.toJson();
    }

    data['_id'] = id;
    data['email'] = email;
    data['authMethod'] = authMethod;
    data['approvalStatus'] = approvalStatus;

    data['emailVerified'] = emailVerified;
    data['mobileVerified'] = mobileVerified;
    data['registrationStep'] = registrationStep;

    data['loginApproved'] = loginApproved;
    data['isActive'] = isActive;

    data['clientId'] = clientId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    data['mobile'] = mobile;
    data['__v'] = v;

    data['profileImage'] = profileImage;
    data['profileImageUrl'] = profileImageUrl;
    data['role'] = role;

    return data;
  }
}
class Profile {
  String? name;

  Profile({this.name});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
class LiveLocation {
  String? lastUpdated;

  LiveLocation({this.lastUpdated});

  LiveLocation.fromJson(Map<String, dynamic> json) {
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    return {
      'lastUpdated': lastUpdated,
    };
  }
}