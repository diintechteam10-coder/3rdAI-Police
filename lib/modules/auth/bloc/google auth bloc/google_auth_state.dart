// import '../../models/google%20login/response/send_email_response.dart';
// import '../../models/google_user_model.dart';

// abstract class GoogleAuthState {
//   const GoogleAuthState();
// }

// class GoogleAuthInitial extends GoogleAuthState {
//   const GoogleAuthInitial();
// }

// class GoogleAuthLoading extends GoogleAuthState {
//   const GoogleAuthLoading();
// }

// class GoogleAuthSuccess extends GoogleAuthState {
//   final GoogleUserModel user;
//   final EmailCheckResponse backendResponse;

//   const GoogleAuthSuccess(this.user, this.backendResponse);
// }

// class GoogleAuthFailure extends GoogleAuthState {
//   final String message;

//   const GoogleAuthFailure(this.message);
// }



import 'package:equatable/equatable.dart';
import '../../models/google login/response/send_email_response.dart';

abstract class GoogleSignInState extends Equatable {
  const GoogleSignInState();
  
  @override
  List<Object?> get props => [];
}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  final GoogleSignInResponse response;
  const GoogleSignInSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class GoogleSignInError extends GoogleSignInState {
  final String message;
  const GoogleSignInError(this.message);

  @override
  List<Object?> get props => [message];
}
