abstract class VerifyResetOtpEvent {}

class VerifyResetOtpSubmitted extends VerifyResetOtpEvent {
  final String email;
  final String otp;

  VerifyResetOtpSubmitted({required this.email, required this.otp});
}
