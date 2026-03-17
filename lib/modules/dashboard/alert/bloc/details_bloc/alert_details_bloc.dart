import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/alert_details_repo.dart';
import '../../repository/update_alert_status_repo.dart';
import '../../models/citizen/request/update_case_status_request.dart';
import 'alert_details_event.dart';
import 'alert_details_state.dart';

class AlertDetailsBloc extends Bloc<AlertDetailsEvent, AlertDetailsState> {
  final GetPartnerAlertDetailsRepository _detailsRepo;
  final UpdateAlertStatusRepository _updateRepo;

  AlertDetailsBloc({
    required GetPartnerAlertDetailsRepository detailsRepo,
    required UpdateAlertStatusRepository updateRepo,
  }) : _detailsRepo = detailsRepo,
       _updateRepo = updateRepo,
       super(AlertDetailsInitial()) {
    on<FetchAlertDetails>(_onFetchAlertDetails);
    on<UpdateStatus>(_onUpdateStatus);
  }

  Future<void> _onFetchAlertDetails(
    FetchAlertDetails event,
    Emitter<AlertDetailsState> emit,
  ) async {
    if (state is! AlertDetailsLoaded) {
      emit(AlertDetailsLoading());
    }

    try {
      final detailsResponse = await _detailsRepo.getAlertDetails(event.alertId);

      if (detailsResponse.success == true && detailsResponse.data != null) {
        final alert = detailsResponse.data!.alert;
        final allowedStatuses = detailsResponse.data!.allowedNextStatuses ?? [];
        final basisTypes = detailsResponse.data!.availableBasisTypes ?? [];

        emit(
          AlertDetailsLoaded(
            alert: alert!,
            allowedStatuses: allowedStatuses,
            basisTypes: basisTypes,
          ),
        );
      } else {
        emit(AlertDetailsError("Failed to fetch alert details"));
      }
    } catch (e) {
      emit(AlertDetailsError(e.toString()));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateStatus event,
    Emitter<AlertDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is AlertDetailsLoaded) {
      emit(AlertStatusUpdating(
        alert: currentState.alert,
        allowedStatuses: currentState.allowedStatuses,
        basisTypes: currentState.basisTypes,
      ));
    } else {
      // Fallback for unexpected state, though it should normally be AlertDetailsLoaded
      // This part might need adjustment depending on if AlertStatusUpdating can be emitted from other states
    }
    try {
      final response = await _updateRepo.updateAlertStatus(
        event.alertId,
        UpdateAlertStatusRequest(
          status: event.status,
          basisType: event.basisType,
          description: event.note ?? "Status updated from mobile app",
        ),
      );

      if (response.success == true) {
        emit(AlertStatusUpdated("Status updated successfully", event.status));
        add(FetchAlertDetails(event.alertId));
      } else {
        emit(AlertDetailsError(response.message ?? "Failed to update status"));
        if (currentState is AlertDetailsLoaded) {
          emit(currentState);
        }
      }
    } catch (e) {
      emit(AlertDetailsError(e.toString()));
      if (currentState is AlertDetailsLoaded) {
        emit(currentState);
      }
    }
  }
}
