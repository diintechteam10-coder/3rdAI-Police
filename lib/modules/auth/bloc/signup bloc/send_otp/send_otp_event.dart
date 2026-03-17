import '../../../view/registration view/otp_type.dart';

abstract class SendOtpEvent {
  const SendOtpEvent();
}

class SendOtpInitialized extends SendOtpEvent {
  final OtpType type;
  final String email;
  const SendOtpInitialized({required this.type, this.email = ''});
}

class SendOtpInputChanged extends SendOtpEvent {
  final String input;
  const SendOtpInputChanged({required this.input});
}

class SendOtpChannelChanged extends SendOtpEvent {
  final OtpChannel channel;
  const SendOtpChannelChanged({required this.channel});
}

class SendOtpSubmitted extends SendOtpEvent {
  final String email;
  final String password;

  const SendOtpSubmitted({required this.email, required this.password});
}
