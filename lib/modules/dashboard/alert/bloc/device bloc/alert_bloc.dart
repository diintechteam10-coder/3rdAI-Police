// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'alert_event.dart';
// // import 'alert_state.dart';
// // import '../models/alert_model.dart';

// // class AlertBloc extends Bloc<AlertEvent, AlertState> {
// //   AlertBloc() : super(AlertState()) {
// //     on<LoadAlerts>(_onLoadAlerts);
// //     on<ChangeAlertCategory>(_onChangeCategory);
// //     on<ToggleView>(_onToggleView);
// //   }

// //   void _onLoadAlerts(LoadAlerts event, Emitter<AlertState> emit) {
// //     final dummyAlerts = List.generate(
// //       10,
// //       (index) => AlertModel(
// //         id: index.toString(),
// //         title: "Alert $index",
// //         description: "This is alert description",
// //         latitude: 28.6139,
// //         longitude: 77.2090,
// //         type: index % 2 == 0 ? AlertType.device : AlertType.person,
// //         createdAt: DateTime.now(),
// //       ),
// //     );

// //     emit(state.copyWith(alerts: dummyAlerts));
// //   }

// //   void _onChangeCategory(
// //       ChangeAlertCategory event, Emitter<AlertState> emit) {
// //     emit(state.copyWith(selectedType: event.type));
// //   }

// //   void _onToggleView(ToggleView event, Emitter<AlertState> emit) {
// //     emit(state.copyWith(isMapView: !state.isMapView));
// //   }
// // }

// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../models/alert_model.dart';
// import 'alert_event.dart';
// import 'alert_state.dart';

// class AlertBloc extends Bloc<AlertEvent, AlertState> {
//   AlertBloc() : super(AlertState.initial()) {
//     on<LoadAlerts>(_onLoadAlerts);
//     on<ToggleView>((event, emit) {
//       emit(state.copyWith(isMapView: !state.isMapView));
//     });
//     on<ChangeAlertType>((event, emit) {
//       emit(state.copyWith(selectedType: event.type));
//     });
//     on<ChangeAlertCategoryFilter>((event, emit) {
//       emit(state.copyWith(selectedCategory: event.category));
//     });
//   }

//   void _onLoadAlerts(LoadAlerts event, Emitter<AlertState> emit) {
//     final dummyAlerts = [
//       AlertModel(
//         id: "1",
//         title: "Camera Offline",
//         description: "Camera 12 is offline",
//         latitude: 28.6139,
//         longitude: 77.2090,
//         createdAt: DateTime.now(),
//         type: AlertType.device,
//         category: AlertCategory.deviceHealth,
//       ),
//       AlertModel(
//         id: "2",
//         title: "Face Match Found",
//         description: "Watchlist person detected",
//         latitude: 28.6145,
//         longitude: 77.2100,
//         createdAt: DateTime.now(),
//         type: AlertType.person,
//         category: AlertCategory.aiDetection,
//       ),
//       AlertModel(
//         id: "3",
//         title: "Gunshot Detected",
//         description: "Possible gunshot near Sector 21",
//         latitude: 28.6150,
//         longitude: 77.2120,
//         createdAt: DateTime.now(),
//         type: AlertType.person,
//         category: AlertCategory.emergency,
//       ),
//     ];

//     emit(state.copyWith(alerts: dummyAlerts));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/device/device_alert_model.dart';
import '../../models/device/filter_model.dart';
import 'alert_event.dart';
import 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc() : super(AlertState.initial()) {
    on<LoadAlerts>(_onLoad);
    on<ApplyFilter>(_onApply);
    on<ClearFilter>(_onClear);
  }

  void _onLoad(LoadAlerts event, Emitter<AlertState> emit) {
    final alerts = _dummyData();
    emit(state.copyWith(allAlerts: alerts, visibleAlerts: alerts));
  }

  void _onApply(ApplyFilter event, Emitter<AlertState> emit) {
    final filtered = state.allAlerts.where((alert) {
      final matchType =
          event.filter.types.isEmpty || event.filter.types.contains(alert.type);

      final matchSubType =
          event.filter.subTypes.isEmpty ||
          event.filter.subTypes.contains(alert.subType);

      final matchSeverity =
          event.filter.severities.isEmpty ||
          event.filter.severities.contains(alert.severity);

      return matchType && matchSubType && matchSeverity;
    }).toList();

    emit(state.copyWith(visibleAlerts: filtered, filter: event.filter));
  }

  void _onClear(ClearFilter event, Emitter<AlertState> emit) {
    emit(
      state.copyWith(
        visibleAlerts: state.allAlerts,
        filter: DeviceAlertFilter.initial(),
      ),
    );
  }

  List<DeviceAlert> _dummyData() {
    return [
      DeviceAlert(
        id: "1",
        type: DeviceAlertType.connectivity,
        subType: "Camera Offline",
        severity: AlertSeverity.critical,
        createdAt: DateTime.now(),
      ),
      DeviceAlert(
        id: "2",
        type: DeviceAlertType.power,
        subType: "Battery Low",
        severity: AlertSeverity.medium,
        createdAt: DateTime.now(),
      ),
      DeviceAlert(
        id: "3",
        type: DeviceAlertType.hardware,
        subType: "Camera Tampering",
        severity: AlertSeverity.critical,
        createdAt: DateTime.now(),
      ),
      DeviceAlert(
        id: "4",
        type: DeviceAlertType.storage,
        subType: "Recording Failed",
        severity: AlertSeverity.high,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
