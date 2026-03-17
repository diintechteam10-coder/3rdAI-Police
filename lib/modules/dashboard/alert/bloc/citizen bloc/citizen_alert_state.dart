import '../../models/citizen/response/all_assigned_citizen_alerts.dart';
import '../../models/citizen/citizen_filter_model.dart';

class CitizenAlertState {
  final List<AlertModel> allAlerts;
  final List<AlertModel> visibleAlerts;
  final CitizenAlertFilter filter;
  final String selectedStatus;
  final bool isLoading;
  final List<String> basisTypes;

  CitizenAlertState({
    required this.allAlerts,
    required this.visibleAlerts,
    required this.filter,
    required this.selectedStatus,
    required this.isLoading,
    this.basisTypes = const [],
  });

  factory CitizenAlertState.initial() {
    return CitizenAlertState(
      allAlerts: [],
      visibleAlerts: [],
      filter: CitizenAlertFilter(subTypes: []),
      selectedStatus: 'Reported',
      isLoading: false,
      basisTypes: [],
    );
  }

  CitizenAlertState copyWith({
    List<AlertModel>? allAlerts,
    List<AlertModel>? visibleAlerts,
    CitizenAlertFilter? filter,
    String? selectedStatus,
    bool? isLoading,
    List<String>? basisTypes,
  }) {
    return CitizenAlertState(
      allAlerts: allAlerts ?? this.allAlerts,
      visibleAlerts: visibleAlerts ?? this.visibleAlerts,
      filter: filter ?? this.filter,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isLoading: isLoading ?? this.isLoading,
      basisTypes: basisTypes ?? this.basisTypes,
    );
  }
}
