import '../../models/approval_status/approval_status_response_model.dart';

abstract class ApprovalStatusState {}

class ApprovalStatusInitial extends ApprovalStatusState {}

class ApprovalStatusLoading extends ApprovalStatusState {}

class ApprovalStatusLoaded extends ApprovalStatusState {
  final ApprovalStatusResponseModel response;
  ApprovalStatusLoaded(this.response);
}

class ApprovalStatusError extends ApprovalStatusState {
  final String message;
  ApprovalStatusError(this.message);
}
