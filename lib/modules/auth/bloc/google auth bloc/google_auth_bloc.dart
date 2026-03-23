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



import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../models/google login/request/send_email_request.dart';
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

  Future<GoogleSignInAccount?> getGoogleUser() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Force account picker every time
      await googleSignIn.signOut(); 
      return await googleSignIn.signIn();
    } catch (e) {
      print("🚨 [SDK ERROR] $e");
      return null;
    }
  }

  Future<void> _onGoogleSignInPressed(
  OnGoogleSignInPressed event,
  Emitter<GoogleSignInState> emit,
) async {
  emit(GoogleSignInLoading());

  try {
    print("🎯 Google Sign-In Started");

    // ✅ STEP 1: Firebase + Google login
    final user = await _repository.signInWithGoogle();

    if (user == null) {
      emit(const GoogleSignInError("Google Sign-In cancelled."));
      return;
    }

    print("📧 Firebase Email: ${user.email}");

    // ✅ STEP 2: clientId
    final storage = SecureStorageService.instance;
    final clientId = await storage.read(AppKeys.clientId) ?? '778205';

    // ✅ STEP 3: API request
    final request = GoogleSignInRequest(
      email: user.email ?? "",
      clientId: clientId,
    );

    final response = await _repository.googleSignIn(request);

    // ✅ STEP 4: Handle response
    if (response.success) {
      if (response.registrationComplete) {
        final token = response.data.token;

        if (token != null) {
          await storage.write(key: AppKeys.token, value: token);
          await storage.write(key: "loginType", value: "google"); // 🔥 IMPORTANT
        }
      }

      emit(GoogleSignInSuccess(response));
    } else {
      emit(GoogleSignInError(response.message));
    }
  } catch (e) {
    emit(GoogleSignInError(e.toString()));
  }
}
}
