import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/reset_password/reset_password_request.dart';
import '../../repository/forgot_password_repository.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ForgotPasswordRepository repository;

  ResetPasswordBloc({required this.repository}) : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());
    try {
      final secureStorage = SecureStorageService.instance;
      final clientId = await secureStorage.read(AppKeys.clientId) ?? '778205';

      final request = ResetPasswordRequest(
        email: event.email,
        resetToken: event.resetToken,
        newPassword: event.newPassword,
        clientId: clientId,
      );

      final response = await repository.resetPassword(request);

      if (response.success) {
        emit(ResetPasswordSuccess(message: response.message));
      } else {
        emit(ResetPasswordError(error: response.message));
      }
    } catch (e) {
      emit(ResetPasswordError(error: e.toString()));
    }
  }
}
