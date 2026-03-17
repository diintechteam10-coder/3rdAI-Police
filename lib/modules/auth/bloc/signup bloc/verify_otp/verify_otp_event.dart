import '../../../view/registration view/otp_type.dart';

abstract class VerifyOtpEvent {}

class VerifyOtpInitialized extends VerifyOtpEvent {
  final OtpType type;
  final String input;
  final String email;

  VerifyOtpInitialized({
    required this.type,
    required this.input,
    this.email = '',
  });
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String otp;

  VerifyOtpSubmitted({required this.otp});
}
