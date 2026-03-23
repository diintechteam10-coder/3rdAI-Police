abstract class ResendResetOtpState {}

class ResendResetOtpInitial extends ResendResetOtpState {}

class ResendResetOtpLoading extends ResendResetOtpState {}

class ResendResetOtpSuccess extends ResendResetOtpState {
  final String message;

  ResendResetOtpSuccess({required this.message});
}

class ResendResetOtpError extends ResendResetOtpState {
  final String error;

  ResendResetOtpError({required this.error});
}
