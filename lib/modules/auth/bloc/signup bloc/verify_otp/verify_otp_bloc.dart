import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_keys.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../../models/registration/requests/resend_email_otp_request_model.dart';
import '../../../models/registration/requests/resend_mobile_otp_request_model.dart';
import '../../../models/registration/requests/verify_email_otp_request.dart';
import '../../../models/registration/requests/verify_phone_otp_request_model.dart';
import '../../../repository/verify_email_otp_repo.dart';
import '../../../repository/verify_phone_otp_repo.dart';
import '../../../view/registration view/otp_type.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyEmailOtpRepo emailRepo;
  final VerifyPhoneOtpRepo phoneRepo;

  VerifyOtpBloc({required this.emailRepo, required this.phoneRepo})
    : super(const VerifyOtpState(type: OtpType.email)) {
    on<VerifyOtpInitialized>((event, emit) {
      emit(
        state.copyWith(
          type: event.type,
          input: event.input,
          email: event.email,
          channel: event.channel ?? state.channel,
        ),
      );
    });

    on<VerifyOtpSubmitted>(_onSubmit);
    on<ResendOtpRequested>(_onResendOtp);
  }

  Future<void> _onSubmit(
    VerifyOtpSubmitted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    try {
      emit(
        state.copyWith(isLoading: true, isSuccess: false, errorMessage: null),
      );

      final storage = SecureStorageService.instance;
      final clientId = await storage.read(AppKeys.clientId) ?? "778205";

      if (state.type == OtpType.email) {
        final request = VerifyOtpRequestModel(
          email: state.input,
          otp: event.otp,
          clientId: clientId,
        );

        final response = await emailRepo.verifyemailOtp(request);

        if (response.success == true) {
          emit(
            state.copyWith(
              isLoading: false,
              isSuccess: true,
              input: response.data?.email ?? state.input,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: response.message ?? 'Verification failed',
            ),
          );
        }
      } else {
        final request = VerifyPhoneOtpRequestModel(
          email: state.email,
          phone: state.input,
          otp: event.otp,
          clientId: clientId,
        );

        final response = await phoneRepo.verifyphoneOtp(request);

        if (response.success == true) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: response.message ?? 'Verification failed',
            ),
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          resendLoading: true,
          resendSuccess: false,
          resendMessage: null,
        ),
      );

      final storage = SecureStorageService.instance;
      final clientId = await storage.read(AppKeys.clientId) ?? "778205";

      if (state.type == OtpType.email) {
        final request = ResendEmailOtpRequestModel(
          email: state.input,
          clientId: clientId,
        );

        final response = await emailRepo.resendEmailOtp(request);

        if (response.success) {
          emit(
            state.copyWith(
              resendLoading: false,
              resendSuccess: true,
              resendMessage: response.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              resendLoading: false,
              resendSuccess: false,
              resendMessage: response.message,
            ),
          );
        }
      } else {
        final request = ResendMobileOtpRequestModel(
          email: state.email,
          otpMethod: state.channel.name, // Using dynamic channel name
          clientId: clientId,
        );

        final response = await phoneRepo.resendMobileOtp(request);

        if (response.success) {
          emit(
            state.copyWith(
              resendLoading: false,
              resendSuccess: true,
              resendMessage: response.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              resendLoading: false,
              resendSuccess: false,
              resendMessage: response.message,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          resendLoading: false,
          resendSuccess: false,
          resendMessage: e.toString(),
        ),
      );
    }
  }
}
