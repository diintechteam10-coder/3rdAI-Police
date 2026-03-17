import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/citizen/citizen_filter_model.dart';
import '../../repository/get_all_assigned_citizen_alerts_repo.dart';
import 'citizen_alert_event.dart';
import 'citizen_alert_state.dart';
import '../../repository/get_basis_repo.dart';

class CitizenAlertBloc extends Bloc<CitizenAlertEvent, CitizenAlertState> {
  final GetAlertsRepository repository;

  CitizenAlertBloc({required this.repository})
    : super(CitizenAlertState.initial()) {
    on<LoadCitizenAlerts>(_onLoad);
    on<ApplyCitizenFilter>(_onApply);
    on<ClearCitizenFilter>(_onClear);
    on<ChangeCitizenStatusFilter>(_onChangeStatusFilter);
    on<UpdateCitizenAlertStatus>(_onUpdateAlertStatus);
    // on<LoadBasisTypes>(_onLoadBasisTypes);
  }

  // final GetBasisTypesRepository _basisRepo = GetBasisTypesRepository();

  Future<void> _onLoad(
    LoadCitizenAlerts event,
    Emitter<CitizenAlertState> emit,
  ) async {
    if (state.allAlerts.isEmpty) {
      emit(state.copyWith(isLoading: true));
    }
    try {
      final response = await repository.getAlerts();
      if (response.success == true && response.data?.alerts != null) {
        emit(
          state.copyWith(
            allAlerts: response.data!.alerts,
            filter: CitizenAlertFilter(subTypes: []),
            isLoading: false,
          ),
        );
        _updateVisibleAlerts(emit);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print("Error loading citizen alerts: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onApply(ApplyCitizenFilter event, Emitter<CitizenAlertState> emit) {
    emit(state.copyWith(filter: event.filter));
    _updateVisibleAlerts(emit);
  }

  void _onClear(ClearCitizenFilter event, Emitter<CitizenAlertState> emit) {
    emit(state.copyWith(filter: CitizenAlertFilter(subTypes: [])));
    _updateVisibleAlerts(emit);
  }

  void _onChangeStatusFilter(
    ChangeCitizenStatusFilter event,
    Emitter<CitizenAlertState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
    _updateVisibleAlerts(emit);
  }

  Future<void> _onUpdateAlertStatus(
    UpdateCitizenAlertStatus event,
    Emitter<CitizenAlertState> emit,
  ) async {
    final success = await repository.updateAlertStatus(
      alertId: event.alertId,
      status: event.newStatus,
      basisType: event.basisType,
      note: event.note,
    );

    if (success) {
      // Note: AlertModel doesn't have copyWith by default from json_serializable usually,
      // but we can manually refresh or map if needed. For now, let's just trigger a reload or manual update if possible.
      // Since it's a list, we can just reload the alerts to get the latest state from backend.
      add(LoadCitizenAlerts());
    }
  }

  void _updateVisibleAlerts(Emitter<CitizenAlertState> emit) {
    final filtered = state.allAlerts.where((alert) {
      final matchesStatus =
          alert.status?.toLowerCase() == state.selectedStatus.toLowerCase();
      final matchesSubType =
          state.filter.subTypes.isEmpty ||
          state.filter.subTypes.contains(alert.title);
      return matchesStatus && matchesSubType;
    }).toList();

    emit(state.copyWith(visibleAlerts: filtered));
  }
}

//   Future<void> _onLoadBasisTypes(
//     LoadBasisTypes event,
//     Emitter<CitizenAlertState> emit,
//   ) async {
//     try {
//       final response = await _basisRepo.getBasisTypes(event.category);
//       if (response.success == true && response.data?.basisTypes != null) {
//         emit(state.copyWith(basisTypes: response.data!.basisTypes));
//       }
//     } catch (e) {
//       print("Error loading basis types in CitizenAlertBloc: $e");
//     }
//   }
// }
