import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/routes/auth_route_observer.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../auth/view/registration view/otp_type.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartSplashEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));

      final storage = SecureStorageService.instance;

      final token = await storage.read(AppKeys.token);
      final clientId = await storage.read(AppKeys.clientId);

      print("🚀 --- STATUS FETCHED IN SPLASH SCREEN --- 🚀");
      print("Token: ${token ?? "No token"}");
      print("🏢 STORED CLIENT ID: ${clientId ?? "No Client ID"}");
      print("------------------------------------------");

      if (token != null && token.isNotEmpty) {
        emit(SplashCompleted(nextRoute: RouteNames.bottomNav));
        return;
      }

      // If clientId is missing, go to select client screen
      if (clientId == null || clientId.isEmpty) {
        emit(SplashCompleted(nextRoute: RouteNames.selectClientScreen));
        return;
      }

      final lastRoute = await storage.read(AuthRouteObserver.lastRouteKey);

      if (lastRoute != null && lastRoute.isNotEmpty) {
        final lastType = await storage.read(AuthRouteObserver.lastRouteTypeKey);
        final lastEmail = await storage.read(
          AuthRouteObserver.lastRouteEmailKey,
        );
        final lastInput = await storage.read(
          AuthRouteObserver.lastRouteInputKey,
        );

        Map<String, dynamic>? args;
        if (lastType != null) {
          try {
            final otpType = OtpType.values.firstWhere(
              (e) => e.name == lastType,
              orElse: () => OtpType.email,
            );
            args = {'type': otpType};
            if (lastEmail != null) args['email'] = lastEmail;
            if (lastInput != null) args['input'] = lastInput;
          } catch (_) {}
        }

        emit(SplashCompleted(nextRoute: lastRoute, arguments: args));
      } else {
        emit(SplashCompleted(nextRoute: RouteNames.signinMethodsScreen));
      }
    });
  }
}
