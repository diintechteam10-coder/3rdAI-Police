// import '../models/alert_model.dart';

// class AlertState {
//   final List<AlertModel> alerts;
//   final AlertType selectedType;
//   final bool isMapView;
//   final bool isLoading;

//   AlertState({
//     this.alerts = const [],
//     this.selectedType = AlertType.device,
//     this.isMapView = false,
//     this.isLoading = false,
//   });

//   AlertState copyWith({
//     List<AlertModel>? alerts,
//     AlertType? selectedType,
//     bool? isMapView,
//     bool? isLoading,
//   }) {
//     return AlertState(
//       alerts: alerts ?? this.alerts,
//       selectedType: selectedType ?? this.selectedType,
//       isMapView: isMapView ?? this.isMapView,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }

// import '../models/alert_model.dart';

// class AlertState {
//   final List<AlertModel> alerts;
//   final AlertType selectedType;
//   final AlertCategory selectedCategory;
//   final bool isMapView;

//   AlertState({
//     required this.alerts,
//     required this.selectedType,
//     required this.selectedCategory,
//     required this.isMapView,
//   });

//   AlertState copyWith({
//     List<AlertModel>? alerts,
//     AlertType? selectedType,
//     AlertCategory? selectedCategory,
//     bool? isMapView,
//   }) {
//     return AlertState(
//       alerts: alerts ?? this.alerts,
//       selectedType: selectedType ?? this.selectedType,
//       selectedCategory: selectedCategory ?? this.selectedCategory,
//       isMapView: isMapView ?? this.isMapView,
//     );
//   }

//   factory AlertState.initial() {
//     return AlertState(
//       alerts: [],
//       selectedType: AlertType.device,
//       selectedCategory: AlertCategory.emergency,
//       isMapView: false,
//     );
//   }
// }

import '../../models/device/device_alert_model.dart';
import '../../models/device/filter_model.dart';

class AlertState {
  final List<DeviceAlert> allAlerts;
  final List<DeviceAlert> visibleAlerts;
  final DeviceAlertFilter filter;

  AlertState({
    required this.allAlerts,
    required this.visibleAlerts,
    required this.filter,
  });

  factory AlertState.initial() {
    return AlertState(
      allAlerts: [],
      visibleAlerts: [],
      filter: DeviceAlertFilter.initial(),
    );
  }

  AlertState copyWith({
    List<DeviceAlert>? allAlerts,
    List<DeviceAlert>? visibleAlerts,
    DeviceAlertFilter? filter,
  }) {
    return AlertState(
      allAlerts: allAlerts ?? this.allAlerts,
      visibleAlerts: visibleAlerts ?? this.visibleAlerts,
      filter: filter ?? this.filter,
    );
  }
}
