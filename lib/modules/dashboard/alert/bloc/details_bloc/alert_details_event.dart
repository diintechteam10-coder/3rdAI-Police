
abstract class AlertDetailsEvent {}

class FetchAlertDetails extends AlertDetailsEvent {
  final String alertId;
  FetchAlertDetails(this.alertId);
}

class UpdateStatus extends AlertDetailsEvent {
  final String alertId;
  final String status;
  final String basisType;
  final String? note;

  UpdateStatus({
    required this.alertId,
    required this.status,
    required this.basisType,
    this.note,
  });
}
