class UpdateAlertStatusRequest {
  final String status;
  final String basisType;
  final String description;

  UpdateAlertStatusRequest({
    required this.status,
    required this.basisType,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "basisType": basisType,
      "description": description,
    };
  }
}