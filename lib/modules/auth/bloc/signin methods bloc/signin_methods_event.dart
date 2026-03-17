abstract class SigninMethodsEvent {}

class ToggleInfoEvent extends SigninMethodsEvent {}

class GoogleSigninRequested extends SigninMethodsEvent {}

class LoginRequested extends SigninMethodsEvent {}
class SignupRequested extends SigninMethodsEvent {} // ✅ NEW