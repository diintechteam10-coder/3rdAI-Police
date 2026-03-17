import 'package:equatable/equatable.dart';

class OtpResponse extends Equatable {
  final bool success;
  final String message;
  final OtpData? data;

  const OtpResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? OtpData.fromJson(json['data'])
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

  @override
  List<Object?> get props => [success, message, data];
}
class OtpData extends Equatable {
  final String email;
  final String clientId;

  const OtpData({
    required this.email,
    required this.clientId,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      email: json['email'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "clientId": clientId,
    };
  }

  @override
  List<Object?> get props => [email, clientId];
}