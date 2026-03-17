import '../../../view/registration view/otp_type.dart';

class VerifyOtpState {
  final OtpType type;
  final String input;
  final String email; // newly added
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const VerifyOtpState({
    required this.type,
    this.input = '',
    this.email = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  VerifyOtpState copyWith({
    OtpType? type,
    String? input,
    String? email,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return VerifyOtpState(
      type: type ?? this.type,
      input: input ?? this.input,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
