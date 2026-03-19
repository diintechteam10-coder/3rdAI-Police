// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../repository/google_auth_repository.dart';
// import 'google_auth_event.dart';
// import 'google_auth_state.dart';

// class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
//   final GoogleAuthRepository _repository;

//   GoogleAuthBloc({required GoogleAuthRepository repository})
//     : _repository = repository,
//       super(const GoogleAuthInitial()) {
//     on<GoogleSignInRequested>(_onGoogleSignInRequested);
//     on<GoogleSignOutRequested>(_onGoogleSignOutRequested);
//   }
// Future<void> _onGoogleSignInRequested(
//   GoogleSignInRequested event,
//   Emitter<GoogleAuthState> emit,
// ) async {
//   emit(const GoogleAuthLoading());

//   try {
//     final user = await _repository.signInWithGoogle();

//     if (user != null) {
//       // 🔥 Terminal logs
//       print("✅ GOOGLE LOGIN SUCCESS");

//       print("📧 Email: ${user.email}");
//       print("👤 Name: ${user.name}");
//       print("🆔 UID: ${user.uid}");
//       print("🔑 Firebase Token: ${user.idToken}");
//       print("🔑 Access Token: ${user.accessToken}");

//       final backendResponse = await _repository.checkGoogleEmail(user.email ?? "");
//       print("🌐 BACKEND CHECK SUCCESS: ${backendResponse.message}");

//       emit(GoogleAuthSuccess(user, backendResponse));
//     } else {
//       print("❌ Google Sign-in cancelled by user");
//       emit(const GoogleAuthFailure('Sign in canceled.'));
//     }
//   } catch (e) {
//     print("🚨 GOOGLE AUTH ERROR: $e");
//     emit(GoogleAuthFailure('Authentication failed: ${e.toString()}'));
//   }
// }
//   // Future<void> _onGoogleSignInRequested(
//   //   GoogleSignInRequested event,
//   //   Emitter<GoogleAuthState> emit,
//   // ) async {
//   //   emit(const GoogleAuthLoading());

//   //   try {
//   //     final user = await _repository.signInWithGoogle();

//   //     if (user != null) {
//   //       emit(GoogleAuthSuccess(user));
//   //     } else {
//   //       // User canceled the sign-in
//   //       emit(const GoogleAuthFailure('Sign in canceled.'));
//   //     }
//   //   } catch (e) {
//   //     emit(GoogleAuthFailure('Authentication failed: ${e.toString()}'));
//   //   }
//   // }


//   Future<void> _onGoogleSignOutRequested(
//     GoogleSignOutRequested event,
//     Emitter<GoogleAuthState> emit,
//   ) async {
//     try {
//       await _repository.signOut();
//       emit(const GoogleAuthInitial());
//     } catch (e) {
//       // Could emit an error state here if needed
//       emit(GoogleAuthFailure('Failed to sign out: ${e.toString()}'));
//     }
//   }
// }



import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../repository/google_auth_repository.dart';
import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final GoogleAuthRepository _repository;

  GoogleSignInBloc({required GoogleAuthRepository repository})
      : _repository = repository,
        super(GoogleSignInInitial()) {
    on<OnGoogleSignInPressed>(_onGoogleSignInPressed);
  }

  Future<void> _onGoogleSignInPressed(
    OnGoogleSignInPressed event,
    Emitter<GoogleSignInState> emit,
  ) async {
    emit(GoogleSignInLoading());

    try {
      print("🎯 [BLOC] Google Sign-In Started");

      // 1. Get user from Google/Firebase
      final user = await _repository.signInWithGoogle();
      
      if (user == null) {
        print("⚠️ [BLOC] Google Sign-In cancelled by user");
        emit(const GoogleSignInError("Google Sign-In cancelled."));
        return;
      }

      print("📧 [BLOC] Email obtained: ${user.email}");

      // 2. Get clientId from storage (or use default)
      final storage = SecureStorageService.instance;
      final clientId = await storage.read(AppKeys.clientId) ?? '778205';
      print("🆔 [BLOC] Using ClientId: $clientId");

     
      final backendResponse = await _repository.checkGoogleEmail(user.email ?? "");
      print("🌐 BACKEND CHECK SUCCESS: ${backendResponse.message}");

      if (backendResponse.success) {
        print("✅ [BLOC] Backend Verification Success");
        emit(GoogleSignInSuccess(backendResponse));
      } else {
        print("❌ [BLOC] Backend Verification Failed: ${backendResponse.message}");
        emit(GoogleSignInError(backendResponse.message));
      }
    } catch (e) {
      print("🚨 [BLOC] Unhandled Error: $e");
      emit(GoogleSignInError("An error occurred during Google Sign-In: ${e.toString()}"));
    }
  }
}
