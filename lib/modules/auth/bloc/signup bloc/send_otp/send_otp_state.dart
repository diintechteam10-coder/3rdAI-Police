import '../../../view/registration view/otp_type.dart';

class SendOtpState {
  final OtpType type;
  final String email;
  final String input;
  final OtpChannel channel;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SendOtpState({
    required this.type,
    this.email = '',
    this.input = '',
    this.channel = OtpChannel.whatsapp,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SendOtpState copyWith({
    OtpType? type,
    String? email,
    String? input,
    OtpChannel? channel,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SendOtpState(
      type: type ?? this.type,
      email: email ?? this.email,
      input: input ?? this.input,
      channel: channel ?? this.channel,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}
