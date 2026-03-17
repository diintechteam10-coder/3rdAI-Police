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
import '../../modules/auth/view/approval_pending_screen.dart';
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
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /// 🔵 SPLASH
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SplashBloc()..add(StartSplashEvent()),
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
                    GoogleAuthBloc(repository: GoogleAuthRepository()),
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
                    GoogleAuthBloc(repository: GoogleAuthRepository()),
              ),
            ],
            child: const LoginScreen(),
          ),
        );
      case RouteNames.approvalPendingScreen:
        return MaterialPageRoute(builder: (_) => const ApprovalPendingScreen());
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

        if (args is Map) {
          type = args['type'] as OtpType? ?? OtpType.email;
          input = args['input']?.toString() ?? '';
          email = args['email']?.toString() ?? '';
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                VerifyOtpBloc(
                  emailRepo: VerifyEmailOtpRepo(),
                  phoneRepo: VerifyPhoneOtpRepo(),
                )..add(
                  VerifyOtpInitialized(type: type, input: input, email: email),
                ),
            child: OtpVerificationScreen(
              type: type,
              input: input,
              email: email,
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

      /// 🔴 DEFAULT
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
