import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/forgot_password/forgot_password_request.dart';
import '../../repository/forgot_password_repository.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  ForgotPasswordBloc({required this.repository}) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final secureStorage = SecureStorageService.instance;
      final clientId = await secureStorage.read(AppKeys.clientId) ?? '778205';

      final request = ForgotPasswordRequest(
        email: event.email,
        clientId: clientId,
      );

      final response = await repository.forgotPassword(request);

      if (response.success) {
        emit(ForgotPasswordSuccess(message: response.message));
      } else {
        emit(ForgotPasswordError(error: response.message));
      }
    } catch (e) {
      emit(ForgotPasswordError(error: e.toString()));
    }
  }
}
