import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../models/login/requests/login_request_model.dart';
import '../../repository/login_repo.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final request = LoginRequestModel(
        email: event.email,
        password: event.password,
      );

      final response = await loginRepository.login(request);

      final bool isVerified = response.data?.partner?.isVerified ?? false;

      if (response.success == true && (response.data?.token != null || isVerified == false)) {
        if (response.data?.token != null) {
          // Save token
          await SecureStorageService.instance.write(
            key: AppKeys.token,
            value: response.data!.token!,
          );
        }
        // Save email for status checks
        final String? email = response.data?.partner?.email ?? event.email;
        if (email != null) {
          await SecureStorageService.instance.write(
            key: AppKeys.email,
            value: email,
          );
        }
        emit(LoginSuccess(response: response));
      } else {
        emit(LoginFailure(error: response.message ?? 'Login failed'));
      }
    } on DioException catch (e) {
      String message = 'Network error occurred';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      } else if (e.response?.statusCode != null) {
        message = 'Server Error: ${e.response?.statusCode}';
      }
      emit(LoginFailure(error: message));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
