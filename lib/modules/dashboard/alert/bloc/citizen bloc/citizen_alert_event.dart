import '../../models/citizen/citizen_filter_model.dart';

abstract class CitizenAlertEvent {}

class LoadCitizenAlerts extends CitizenAlertEvent {}

class ApplyCitizenFilter extends CitizenAlertEvent {
  final CitizenAlertFilter filter;
  ApplyCitizenFilter(this.filter);
}

class ClearCitizenFilter extends CitizenAlertEvent {}

class ChangeCitizenStatusFilter extends CitizenAlertEvent {
  final String status;
  ChangeCitizenStatusFilter(this.status);
}

class UpdateCitizenAlertStatus extends CitizenAlertEvent {
  final String alertId;
  final String newStatus;
  final String basisType;
  final String? note;
  UpdateCitizenAlertStatus(
      this.alertId, this.newStatus, this.basisType, this.note);
}

// class LoadBasisTypes extends CitizenAlertEvent {
//   final String category;
//   LoadBasisTypes(this.category);
// }


