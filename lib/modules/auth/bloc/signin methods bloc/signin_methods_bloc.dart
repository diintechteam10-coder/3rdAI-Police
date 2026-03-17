import 'package:flutter_bloc/flutter_bloc.dart';
import 'signin_methods_event.dart';
import 'signin_methods_state.dart';

class SigninMethodsBloc extends Bloc<SigninMethodsEvent, SigninMethodsState> {
  SigninMethodsBloc() : super(const SigninMethodsInitial()) {
    on<ToggleInfoEvent>((event, emit) {
      emit(SigninMethodsUpdated(showInfo: !state.showInfo));
    });

    on<GoogleSigninRequested>((event, emit) async {
      emit(SigninLoading(showInfo: state.showInfo));

      // Simulate Google Sign-in delay
      await Future.delayed(const Duration(seconds: 2));

      // Redirect to mobile otp instead of email otp
      emit(NavigateToMobileOtp(showInfo: state.showInfo));
    });

    on<LoginRequested>((event, emit) {
      emit(NavigateToLogin(showInfo: state.showInfo));
    });
    on<SignupRequested>((event, emit) {
      // ✅ NEW
      emit(NavigateToSignup(showInfo: state.showInfo));
    });
  }
}
