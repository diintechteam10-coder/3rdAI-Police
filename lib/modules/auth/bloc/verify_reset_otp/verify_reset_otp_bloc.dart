import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/verify_reset_otp/verify_reset_otp_request.dart';
import '../../repository/forgot_password_repository.dart';
import 'verify_reset_otp_event.dart';
import 'verify_reset_otp_state.dart';

class VerifyResetOtpBloc extends Bloc<VerifyResetOtpEvent, VerifyResetOtpState> {
  final ForgotPasswordRepository repository;

  VerifyResetOtpBloc({required this.repository}) : super(VerifyResetOtpInitial()) {
    on<VerifyResetOtpSubmitted>(_onVerifyResetOtpSubmitted);
  }

  Future<void> _onVerifyResetOtpSubmitted(
    VerifyResetOtpSubmitted event,
    Emitter<VerifyResetOtpState> emit,
  ) async {
    emit(VerifyResetOtpLoading());
    try {
      final secureStorage = SecureStorageService.instance;
      final clientId = await secureStorage.read(AppKeys.clientId) ?? '778205';

      final request = VerifyResetOtpRequest(
        email: event.email,
        otp: event.otp,
        clientId: clientId,
      );

      final response = await repository.verifyResetOtp(request);

      if (response.success && response.data != null) {
        emit(VerifyResetOtpSuccess(
          message: response.message,
          resetToken: response.data!.resetToken,
        ));
      } else {
        emit(VerifyResetOtpError(error: response.message));
      }
    } catch (e) {
      emit(VerifyResetOtpError(error: e.toString()));
    }
  }
}
