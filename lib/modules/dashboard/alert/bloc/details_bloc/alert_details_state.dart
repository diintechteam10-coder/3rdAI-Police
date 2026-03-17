import '../../models/citizen/response/alert_details_response.dart';

abstract class AlertDetailsState {}

class AlertDetailsInitial extends AlertDetailsState {}

class AlertDetailsLoading extends AlertDetailsState {}

class AlertDetailsLoaded extends AlertDetailsState {
  final AlertDetails alert;
  final List<String> allowedStatuses;
  final List<String> basisTypes;

  AlertDetailsLoaded({
    required this.alert,
    required this.allowedStatuses,
    required this.basisTypes,
  });
}

class AlertDetailsError extends AlertDetailsState {
  final String message;
  AlertDetailsError(this.message);
}

class AlertStatusUpdating extends AlertDetailsState {
  final AlertDetails alert;
  final List<String> allowedStatuses;
  final List<String> basisTypes;

  AlertStatusUpdating({
    required this.alert,
    required this.allowedStatuses,
    required this.basisTypes,
  });
}

class AlertStatusUpdated extends AlertDetailsState {
  final String message;
  final String newStatus;
  AlertStatusUpdated(this.message, this.newStatus);
}
