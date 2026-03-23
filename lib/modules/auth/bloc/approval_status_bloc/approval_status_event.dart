abstract class ApprovalStatusEvent {}

class CheckApprovalStatus extends ApprovalStatusEvent {
  final String email;
  CheckApprovalStatus(this.email);
}
