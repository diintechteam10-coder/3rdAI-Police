class ApprovalStatusResponseModel {
  bool? success;
  String? message;
  ApprovalStatusData? data;

  ApprovalStatusResponseModel({this.success, this.message, this.data});

  ApprovalStatusResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ApprovalStatusData.fromJson(json['data']) : null;
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

class ApprovalStatusData {
  String? verificationStatus;
  bool? isVerified;
  String? blockedReason;
  String? name;

  ApprovalStatusData({
    this.verificationStatus,
    this.isVerified,
    this.blockedReason,
    this.name,
  });

  ApprovalStatusData.fromJson(Map<String, dynamic> json) {
    verificationStatus = json['verificationStatus'];
    isVerified = json['isVerified'];
    blockedReason = json['blockedReason'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['verificationStatus'] = verificationStatus;
    data['isVerified'] = isVerified;
    data['blockedReason'] = blockedReason;
    data['name'] = name;
    return data;
  }
}
