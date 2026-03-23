import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../repository/approval_status_repo.dart';
import 'approval_status_event.dart';
import 'approval_status_state.dart';

class ApprovalStatusBloc extends Bloc<ApprovalStatusEvent, ApprovalStatusState> {
  final ApprovalStatusRepo repository;

  ApprovalStatusBloc({required this.repository}) : super(ApprovalStatusInitial()) {
    on<CheckApprovalStatus>(_onCheckApprovalStatus);
  }

  Future<void> _onCheckApprovalStatus(
    CheckApprovalStatus event,
    Emitter<ApprovalStatusState> emit,
  ) async {
    emit(ApprovalStatusLoading());

    try {
      final response = await repository.getApprovalStatus(event.email);
      emit(ApprovalStatusLoaded(response));
    } on DioException catch (e) {
      String message = 'Network error occurred';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      }
      emit(ApprovalStatusError(message));
    } catch (e) {
      emit(ApprovalStatusError(e.toString()));
    }
  }
}
