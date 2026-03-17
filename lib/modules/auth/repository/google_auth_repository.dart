import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/secure_storage_service.dart';
import '../models/google login/request/send_email_request.dart';
import '../models/google login/response/send_email_response.dart';
import '../models/google_user_model.dart';

class GoogleAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

Future<GoogleUserModel?> signInWithGoogle() async {
  // Force the account selection dialog by signing out first
  await _googleSignIn.signOut();
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  if (googleUser == null) return null;

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential =
      await _firebaseAuth.signInWithCredential(credential);

  final user = userCredential.user;

  final firebaseToken = await user?.getIdToken();

  return GoogleUserModel(
    email: user?.email ?? "",
    name: user?.displayName ?? "",
    uid: user?.uid ?? "",
    idToken: firebaseToken ?? "",
    accessToken: googleAuth.accessToken ?? "",
  );
}

Future<EmailCheckResponse> checkGoogleEmail(String email) async {
  final storage = SecureStorageService.instance;
  final clientId = await storage.read(AppKeys.clientId) ?? '';

  final request = SendEmailOtpRequestModel(
    email: email,
    clientId: clientId,
  );

  final response = await ApiService.dio.post(
    ApiConstants.checkEmail,
    data: request.toJson(),
    options: Options(extra: {'skipClientId': false}),
  );

  return EmailCheckResponse.fromJson(response.data);
}
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
