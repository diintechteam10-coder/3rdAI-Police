abstract class SigninMethodsState {
  final bool showInfo;
  const SigninMethodsState({required this.showInfo});
}

class SigninMethodsInitial extends SigninMethodsState {
  const SigninMethodsInitial() : super(showInfo: false);
}

class SigninMethodsUpdated extends SigninMethodsState {
  const SigninMethodsUpdated({required bool showInfo})
    : super(showInfo: showInfo);
}

class SigninLoading extends SigninMethodsState {
  const SigninLoading({required bool showInfo}) : super(showInfo: showInfo);
}

class NavigateToLogin extends SigninMethodsState {
  const NavigateToLogin({required bool showInfo}) : super(showInfo: showInfo);
}

class NavigateToSignup extends SigninMethodsState {
  // ✅ NEW
  const NavigateToSignup({required bool showInfo}) : super(showInfo: showInfo);
}

class NavigateToMobileOtp extends SigninMethodsState {
  const NavigateToMobileOtp({required bool showInfo})
    : super(showInfo: showInfo);
}
