import '../../models/google%20login/response/send_email_response.dart';
import '../../models/google_user_model.dart';

abstract class GoogleAuthState {
  const GoogleAuthState();
}

class GoogleAuthInitial extends GoogleAuthState {
  const GoogleAuthInitial();
}

class GoogleAuthLoading extends GoogleAuthState {
  const GoogleAuthLoading();
}

class GoogleAuthSuccess extends GoogleAuthState {
  final GoogleUserModel user;
  final EmailCheckResponse backendResponse;

  const GoogleAuthSuccess(this.user, this.backendResponse);
}

class GoogleAuthFailure extends GoogleAuthState {
  final String message;

  const GoogleAuthFailure(this.message);
}
