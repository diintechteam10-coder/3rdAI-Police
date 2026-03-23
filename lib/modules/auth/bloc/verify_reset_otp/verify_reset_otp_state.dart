abstract class VerifyResetOtpState {}

class VerifyResetOtpInitial extends VerifyResetOtpState {}

class VerifyResetOtpLoading extends VerifyResetOtpState {}

class VerifyResetOtpSuccess extends VerifyResetOtpState {
  final String message;
  final String resetToken;

  VerifyResetOtpSuccess({required this.message, required this.resetToken});
}

class VerifyResetOtpError extends VerifyResetOtpState {
  final String error;

  VerifyResetOtpError({required this.error});
}
