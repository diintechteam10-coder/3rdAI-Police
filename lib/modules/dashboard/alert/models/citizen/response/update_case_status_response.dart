import 'alert_details_response.dart';

class UpdateAlertStatusResponse {
  final bool? success;
  final String? message;
  final UpdateAlertData? data;

  UpdateAlertStatusResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UpdateAlertStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAlertStatusResponse(
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? UpdateAlertData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}
class UpdateAlertData {
  final AlertDetails? alert;
  final List<String>? allowedNextStatuses;
  final String? previousStatus;

  UpdateAlertData({
    this.alert,
    this.allowedNextStatuses,
    this.previousStatus,
  });

  factory UpdateAlertData.fromJson(Map<String, dynamic> json) {
    return UpdateAlertData(
      alert: json["alert"] != null
          ? AlertDetails.fromJson(json["alert"])
          : null,
      allowedNextStatuses: json["allowedNextStatuses"] != null
          ? List<String>.from(json["allowedNextStatuses"])
          : [],
      previousStatus: json["previousStatus"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "alert": alert?.toJson(),
      "allowedNextStatuses": allowedNextStatuses,
      "previousStatus": previousStatus,
    };
  }
}