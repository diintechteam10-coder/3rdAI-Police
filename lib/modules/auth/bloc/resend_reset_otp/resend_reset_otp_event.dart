abstract class ResendResetOtpEvent {}

class ResendResetOtpSubmitted extends ResendResetOtpEvent {
  final String email;

  ResendResetOtpSubmitted({required this.email});
}
