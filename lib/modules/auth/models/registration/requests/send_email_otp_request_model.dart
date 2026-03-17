import 'package:equatable/equatable.dart';

class SendEmailOtpRequestModel extends Equatable {
  final String email;
  final String password;
  final String clientId;

  const SendEmailOtpRequestModel({
    required this.email,
    required this.password,
    required this.clientId,
  });

  /// Convert object to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "clientId": clientId,
    };
  }

  /// Optional: fromJson (agar future me reuse karna ho)
  factory SendEmailOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return SendEmailOtpRequestModel(
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      clientId: json["clientId"] ?? "",
    );
  }

  /// CopyWith (useful in BLoC state updates)
  SendEmailOtpRequestModel copyWith({
    String? email,
    String? password,
    String? clientId,
  }) {
    return SendEmailOtpRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  List<Object?> get props => [email, password, clientId];
}