import 'device_alert_model.dart';

class DeviceAlertFilter {
  final List<DeviceAlertType> types;
  final List<String> subTypes;
  final List<AlertSeverity> severities;

  DeviceAlertFilter({
    required this.types,
    required this.subTypes,
    required this.severities,
  });

  factory DeviceAlertFilter.initial() {
    return DeviceAlertFilter(
      types: [],
      subTypes: [],
      severities: [],
    );
  }
}