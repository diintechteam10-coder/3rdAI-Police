import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/auth/bloc/complete profile bloc/complete_profile_bloc.dart';
import '../../modules/auth/bloc/google auth bloc/google_auth_bloc.dart';
import '../../modules/auth/repository/google_auth_repository.dart';
import '../../modules/auth/bloc/signin methods bloc/signin_methods_bloc.dart';
import '../../modules/auth/bloc/signup bloc/send_otp/send_otp_bloc.dart';
import '../../modules/auth/bloc/signup bloc/send_otp/send_otp_event.dart';
import '../../modules/auth/repository/send_email_otp_repo.dart';
import '../../modules/auth/repository/send_mobile_otp_repo.dart';
import '../../modules/auth/bloc/upload profile pic bloc/upload_pic_bloc.dart';
import '../../modules/auth/repository/upload_profile_pic_repo.dart';
import '../../modules/auth/repository/verify_phone_otp_repo.dart';
import '../../modules/auth/bloc/login bloc/login_bloc.dart';
import '../../modules/auth/repository/login_repo.dart';
import '../../modules/auth/view/login_screen.dart';
import '../../modules/auth/view/registration view/complete_profile_screen.dart';
import '../../modules/auth/view/registration view/upload_profile_pic.dart';
import '../../modules/auth/view/signin_methods_screen.dart';
import '../../modules/auth/view/registration view/otp_type.dart';
import '../../modules/auth/view/registration view/send_otp_screen.dart';
import '../../modules/auth/view/registration view/verify_otp_screen.dart';
import '../../modules/auth/bloc/signup bloc/verify_otp/verify_otp_bloc.dart';
import '../../modules/auth/bloc/signup bloc/verify_otp/verify_otp_event.dart';
import '../../modules/auth/repository/verify_email_otp_repo.dart';
import '../../modules/auth/repository/complete_profile_repo.dart';
import '../../modules/dashboard/bottom nav/bottom nav bloc/bottom_nav_bloc.dart';
import '../../modules/dashboard/bottom nav/bottom_nav_view.dart';
import '../../modules/dashboard/profile/bloc/profile_bloc.dart';
import '../../modules/dashboard/profile/bloc/profile_event.dart';
import '../../modules/dashboard/profile/repository/get_profile_repo.dart';
import '../../modules/spash and onboarding/bloc/splash_bloc.dart';
import '../../modules/spash and onboarding/bloc/splash_event.dart';
import '../../modules/spash and onboarding/view/splash_screen.dart';
import '../../modules/auth/bloc/select%20client%20bloc/select_client_bloc.dart';
import '../../modules/auth/repository/organization_repository.dart';
import '../../modules/auth/view/select_client_screen.dart';
import '../../modules/dashboard/requests/bloc/geo_area/geo_area_bloc.dart';
import '../../modules/dashboard/requests/repository/get_geo_area.dart';
import '../../modules/dashboard/requests/bloc/camera/camera_bloc.dart';
import '../../modules/dashboard/requests/repository/get_geo_camera.dart';
import '../../modules/dashboard/requests/view/map_view/footage_request_tabs_screen.dart';
import '../../modules/auth/bloc/approval_status_bloc/approval_status_bloc.dart';
import '../../modules/auth/repository/approval_status_repo.dart';
import '../../modules/auth/view/approval_status_view.dart';
import '../../modules/auth/bloc/forgot_password/forgot_password_bloc.dart';
import '../../modules/auth/bloc/verify_reset_otp/verify_reset_otp_bloc.dart';
import '../../modules/auth/bloc/reset_password/reset_password_bloc.dart';
import '../../modules/auth/bloc/resend_reset_otp/resend_reset_otp_bloc.dart';
import '../../modules/auth/repository/forgot_password_repository.dart';
import '../../modules/auth/presentation/screens/forgot_password_screen.dart';
import '../../modules/auth/presentation/screens/verify_reset_password_email_otp_screen.dart';
import '../../modules/auth/presentation/screens/reset_password_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /// 🔵 SPLASH
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SplashBloc(repository: ApprovalStatusRepo())..add(StartSplashEvent()),
            child: const SplashScreen(),
          ),
        );

      /// 🔵 SIGNIN METHODS
      case RouteNames.signinMethodsScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => SigninMethodsBloc()),
              BlocProvider(
                create: (_) =>
                    GoogleSignInBloc(repository: GoogleAuthRepository()),
              ),
            ],
            child: const SigninMethodsScreen(),
          ),
        );
      case RouteNames.selectClientScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SelectClientBloc(
              repository: OrganizationRepository(),
            )..add(FetchOrganizations()),
            child: const SelectClientScreen(),
          ),
        );
      case RouteNames.loginScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LoginBloc(loginRepository: LoginRepository()),
              ),
              BlocProvider(
                create: (_) =>
                    GoogleSignInBloc(repository: GoogleAuthRepository()),
              ),
            ],
            child: const LoginScreen(),
          ),
        );
      // case RouteNames.approvalPendingScreen:
      //   return MaterialPageRoute(builder: (_) => const ApprovalPendingScreen());
      case RouteNames.approvalStatus:
        final email = (settings.arguments as Map<String, dynamic>?)?['email'] ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ApprovalStatusBloc(repository: ApprovalStatusRepo()),
            child: ApprovalStatusView(email: email),
          ),
        );
      case RouteNames.sendOtpScreen:
        final args = settings.arguments;
        final OtpType type;
        final String email;

        if (args is OtpType) {
          type = args;
          email = '';
        } else if (args is Map) {
          // Less strict type cast
          type = args['type'] as OtpType? ?? OtpType.email;
          email = args['email']?.toString() ?? '';
        } else {
          type = OtpType.email;
          email = '';
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SendOtpBloc(
              emailRepository: SendEmailOtpRepository(),
              mobileRepository: SendMobileOtpRepo(),
            )..add(SendOtpInitialized(type: type, email: email)),
            child: SendOtpScreen(type: type, email: email),
          ),
        );

      /// 🔵 VERIFY OTP
      case RouteNames.verifyOtpScreen:
        final args = settings.arguments;

        OtpType type = OtpType.email;
        String input = '';
        String email = '';

        OtpChannel? channel;
        if (args is Map) {
          type = args['type'] as OtpType? ?? OtpType.email;
          input = args['input']?.toString() ?? '';
          email = args['email']?.toString() ?? '';
          channel = args['channel'] as OtpChannel?;
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                VerifyOtpBloc(
                  emailRepo: VerifyEmailOtpRepo(),
                  phoneRepo: VerifyPhoneOtpRepo(),
                )..add(
                  VerifyOtpInitialized(
                    type: type,
                    input: input,
                    email: email,
                    channel: channel,
                  ),
                ),
            child: OtpVerificationScreen(
              type: type,
              input: input,
              email: email,
              channel: channel,
            ),
          ),
        );
      case RouteNames.completeProfileScreen:
        final args = settings.arguments;
        String email = '';
        if (args is Map) {
          email = args['email']?.toString() ?? '';
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CompleteProfileBloc(
              completeProfileRepo: CompleteProfileRepo(),
              initialEmail: email,
            ),
            child: const CompleteProfileScreen(),
          ),
        );

      case RouteNames.uploadProfilePicScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => UploadPicBloc(uploadRepo: UploadProfileImageRepo()),
            child: const UploadProfilePicScreen(),
          ),
        );

      case RouteNames.bottomNav:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => BottomNavBloc()),
              BlocProvider(
                create:
                    (_) => ProfileBloc(repository: GetProfileRepository())
                      ..add(FetchProfile()),
              ),
            ],
            child: const BottomNavView(),
          ),
        );

      case RouteNames.footageRequestMap:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => GeoAreaBloc(repository: GetGeoAreaRepository()),
              ),
              BlocProvider(
                create: (_) => CameraBloc(repository: CameraRepository()),
              ),
            ],
            child: const FootageRequestTabsScreen(),
          ),
        );

      case RouteNames.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordBloc(repository: ForgotPasswordRepository()),
            child: const ForgotPasswordScreen(),
          ),
        );

      case RouteNames.verifyEmailOtpScreen:
        final email = (settings.arguments as Map<String, dynamic>?)?['email'] ?? '';
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => VerifyResetOtpBloc(repository: ForgotPasswordRepository()),
              ),
              BlocProvider(
                create: (_) => ResendResetOtpBloc(repository: ForgotPasswordRepository()),
              ),
            ],
            child: VerifyResetPasswordEmailOtpScreen(email: email),
          ),
        );

      case RouteNames.resetPasswordScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] ?? '';
        final resetToken = args?['resetToken'] ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ResetPasswordBloc(repository: ForgotPasswordRepository()),
            child: ResetPasswordScreen(email: email, resetToken: resetToken),
          ),
        );

      /// 🔴 DEFAULT
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
