class GoogleSignInRequest {
  final String email;
  final String clientId;

  GoogleSignInRequest({
    required this.email,
    required this.clientId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "clientId": clientId,
    };
  }

  factory GoogleSignInRequest.fromJson(Map<String, dynamic> json) {
    return GoogleSignInRequest(
      email: json['email'] ?? '',
      clientId: json['clientId'] ?? '',
    );
  }

  GoogleSignInRequest copyWith({
    String? email,
    String? clientId,
  }) {
    return GoogleSignInRequest(
      email: email ?? this.email,
      clientId: clientId ?? this.clientId,
    );
  }
}