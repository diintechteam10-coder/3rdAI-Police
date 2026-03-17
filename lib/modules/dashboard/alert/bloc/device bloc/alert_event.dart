// import '../models/alert_model.dart';

// abstract class AlertEvent {}

// class LoadAlerts extends AlertEvent {}

// class ChangeAlertCategory extends AlertEvent {
//   final AlertType type;
//   ChangeAlertCategory(this.type);
// }

// class ToggleView extends AlertEvent {}



// import '../models/alert_model.dart';

// abstract class AlertEvent {}

// class LoadAlerts extends AlertEvent {}

// class ToggleView extends AlertEvent {}

// class ChangeAlertType extends AlertEvent {
//   final AlertType type;
//   ChangeAlertType(this.type);
// }

// class ChangeAlertCategoryFilter extends AlertEvent {
//   final AlertCategory category;
//   ChangeAlertCategoryFilter(this.category);
// }


import '../../models/device/filter_model.dart';

abstract class AlertEvent {}

class LoadAlerts extends AlertEvent {}

class ApplyFilter extends AlertEvent {
  final DeviceAlertFilter filter;
  ApplyFilter(this.filter);
}

class ClearFilter extends AlertEvent {}