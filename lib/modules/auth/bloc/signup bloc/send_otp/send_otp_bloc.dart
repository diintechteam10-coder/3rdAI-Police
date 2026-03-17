// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../view/registration view/otp_type.dart';
// import 'send_otp_event.dart';
// import 'send_otp_state.dart';

// class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
//   SendOtpBloc()
//       : super(const SendOtpState(type: OtpType.email)) {

//     on<SendOtpInitialized>((event, emit) {
//       emit(state.copyWith(type: event.type));
//     });

//     on<SendOtpInputChanged>((event, emit) {
//       emit(state.copyWith(input: event.input));
//     });

//     on<SendOtpChannelChanged>((event, emit) {
//       emit(state.copyWith(channel: event.channel));
//     });

//     on<SendOtpSubmitted>((event, emit) async {
//       emit(state.copyWith(isLoading: true));

//       await Future.delayed(const Duration(seconds: 2));

//       emit(state.copyWith(isLoading: false, isSuccess: true));
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_keys.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../../models/registration/requests/send_email_otp_request_model.dart';
import '../../../models/registration/requests/send_mobile_otp_request_model.dart';
import '../../../repository/send_email_otp_repo.dart';
import '../../../repository/send_mobile_otp_repo.dart';
import '../../../view/registration view/otp_type.dart';
import 'send_otp_event.dart';
import 'send_otp_state.dart';

class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final SendEmailOtpRepository emailRepository;
  final SendMobileOtpRepo mobileRepository;

  SendOtpBloc({required this.emailRepository, required this.mobileRepository})
    : super(const SendOtpState(type: OtpType.email)) {
    on<SendOtpInitialized>((event, emit) {
      emit(state.copyWith(type: event.type, email: event.email));
    });

    on<SendOtpInputChanged>((event, emit) {
      emit(state.copyWith(input: event.input));
    });

    on<SendOtpChannelChanged>((event, emit) {
      emit(state.copyWith(channel: event.channel));
    });

    on<SendOtpSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
    SendOtpSubmitted event,
    Emitter<SendOtpState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, isSuccess: false));

      final storage = SecureStorageService.instance;
      final clientId = await storage.read(AppKeys.clientId) ?? "778205";

      if (state.type == OtpType.email) {
        final request = SendEmailOtpRequestModel(
          email: event.email,
          password: event.password,
          clientId: clientId,
        );

        final response = await emailRepository.sendemailOtp(request);

        if (response.success == true) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          emit(state.copyWith(isLoading: false));
        }
      } else {
        /// 🔥 Create request model for Mobile
        final request = SendPhoneOtpRequestModel(
          email: state.email,
          phone: event.email, // Phone number is passed in event.email
          otpMethod: state.channel.name,
          clientId: clientId,
        );

        /// 🔥 API CALL
        print('----- DEBUG SEND MOBILE OTP -----');
        print('Email from state (sent to API): "${state.email}"');
        print('Phone from event (sent to API): "${event.email}"');
        print('---------------------------------');

        final response = await mobileRepository.sendmobileotp(request);

        if (response.success == true) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          emit(state.copyWith(isLoading: false));
        }
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
