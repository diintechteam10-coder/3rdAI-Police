import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/google login/request/send_email_request.dart';
import '../models/google login/response/send_email_response.dart';
import '../models/google_user_model.dart';

class GoogleAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();
final Dio _dio = ApiService.dio;
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

  Future<GoogleSignInResponse> googleSignIn(
    GoogleSignInRequest request,
  ) async {
    final response = await _dio.post(
      ApiConstants.googleLogin, // 🔥 create this endpoint
      data: request.toJson(),
      // options: Options(extra: {"skipClientId": true}),
    );

    return GoogleSignInResponse.fromJson(response.data);
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}