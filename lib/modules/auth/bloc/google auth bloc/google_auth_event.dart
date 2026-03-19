// abstract class GoogleAuthEvent {
//   const GoogleAuthEvent();
// }

// class GoogleSignInRequested extends GoogleAuthEvent {
//   const GoogleSignInRequested();
// }

// class GoogleSignOutRequested extends GoogleAuthEvent {
//   const GoogleSignOutRequested();
// }


import 'package:equatable/equatable.dart';

abstract class GoogleSignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnGoogleSignInPressed extends GoogleSignInEvent {}
