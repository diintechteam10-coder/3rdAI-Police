import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/resend_reset_otp/resend_reset_otp_request.dart';
import '../../repository/forgot_password_repository.dart';
import 'resend_reset_otp_event.dart';
import 'resend_reset_otp_state.dart';

class ResendResetOtpBloc extends Bloc<ResendResetOtpEvent, ResendResetOtpState> {
  final ForgotPasswordRepository repository;

  ResendResetOtpBloc({required this.repository}) : super(ResendResetOtpInitial()) {
    on<ResendResetOtpSubmitted>(_onResendResetOtpSubmitted);
  }

  Future<void> _onResendResetOtpSubmitted(
    ResendResetOtpSubmitted event,
    Emitter<ResendResetOtpState> emit,
  ) async {
    emit(ResendResetOtpLoading());
    try {
      final secureStorage = SecureStorageService.instance;
      final clientId = await secureStorage.read(AppKeys.clientId) ?? '778205';

      final request = ResendResetOtpRequest(
        email: event.email,
        clientId: clientId,
      );

      final response = await repository.resendResetOtp(request);

      if (response.success) {
        emit(ResendResetOtpSuccess(message: response.message));
      } else {
        emit(ResendResetOtpError(error: response.message));
      }
    } catch (e) {
      emit(ResendResetOtpError(error: e.toString()));
    }
  }
}
