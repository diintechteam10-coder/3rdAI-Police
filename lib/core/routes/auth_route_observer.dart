import 'package:flutter/material.dart';
import '../../modules/auth/view/registration view/otp_type.dart';
import '../services/secure_storage_service.dart';
import 'route_names.dart';

class AuthRouteObserver extends NavigatorObserver {
  static const String lastRouteKey = 'last_route';
  static const String lastRouteTypeKey = 'last_route_type';
  static const String lastRouteEmailKey = 'last_route_email';
  static const String lastRouteInputKey = 'last_route_input';

  final List<String> _trackedRoutes = [
    RouteNames.signinMethodsScreen,
    RouteNames.loginScreen,
    RouteNames.sendOtpScreen,
    RouteNames.verifyOtpScreen,
    RouteNames.completeProfileScreen,
    RouteNames.uploadProfilePicScreen,
  ];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _saveRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _saveRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _saveRoute(previousRoute);
    }
  }

  Future<void> _saveRoute(Route<dynamic> route) async {
    final routeName = route.settings.name;
    // Don't save if it's not a tracked auth route
    // Also, if someone goes to bottomNav, we might want to clear the auth route, or just let SessionManager clear everything on logout.
    if (routeName == null) return;

    final storage = SecureStorageService.instance;

    // If it's bottomNav, the user completed login. We could clear the last route to start fresh if logged out.
    if (routeName == RouteNames.bottomNav) {
      await storage.delete(lastRouteKey);
      await storage.delete(lastRouteTypeKey);
      await storage.delete(lastRouteEmailKey);
      await storage.delete(lastRouteInputKey);
      return;
    }

    if (!_trackedRoutes.contains(routeName)) {
      return;
    }

    await storage.write(key: lastRouteKey, value: routeName);

    // Clear previous arguments
    await storage.delete(lastRouteTypeKey);
    await storage.delete(lastRouteEmailKey);
    await storage.delete(lastRouteInputKey);

    final args = route.settings.arguments;
    if (args != null) {
      if (args is OtpType) {
        await storage.write(key: lastRouteTypeKey, value: args.name);
      } else if (args is Map) {
        final type = args['type'];
        if (type is OtpType) {
          await storage.write(key: lastRouteTypeKey, value: type.name);
        } else if (type is String) {
          await storage.write(key: lastRouteTypeKey, value: type);
        }

        final email = args['email']?.toString();
        if (email != null && email.isNotEmpty) {
          await storage.write(key: lastRouteEmailKey, value: email);
        }

        final input = args['input']?.toString();
        if (input != null && input.isNotEmpty) {
          await storage.write(key: lastRouteInputKey, value: input);
        }
      }
    }
  }
}
