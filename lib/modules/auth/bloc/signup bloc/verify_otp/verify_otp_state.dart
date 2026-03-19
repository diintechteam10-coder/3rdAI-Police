import '../../../view/registration view/otp_type.dart';

class VerifyOtpState {
  final OtpType type;
  final String input;
  final String email; // newly added
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final OtpChannel channel;
  final bool resendLoading;
  final bool resendSuccess;
  final String? resendMessage;

  const VerifyOtpState({
    required this.type,
    this.input = '',
    this.email = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.channel = OtpChannel.whatsapp,
    this.resendLoading = false,
    this.resendSuccess = false,
    this.resendMessage,
  });

  VerifyOtpState copyWith({
    OtpType? type,
    String? input,
    String? email,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    OtpChannel? channel,
    bool? resendLoading,
    bool? resendSuccess,
    String? resendMessage,
  }) {
    return VerifyOtpState(
      type: type ?? this.type,
      input: input ?? this.input,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      channel: channel ?? this.channel,
      resendLoading: resendLoading ?? this.resendLoading,
      resendSuccess: resendSuccess ?? this.resendSuccess,
      resendMessage: resendMessage ?? this.resendMessage,
    );
  }
}
