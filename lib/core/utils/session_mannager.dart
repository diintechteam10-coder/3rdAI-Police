
import '../services/secure_storage_service.dart';
import 'logger.dart';

class SessionManager {
  static bool _isLoggingOut = false;

  static Future<void> forceLogout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;

    appLog("🚪 Force logout triggered");

    final prefs = await SecureStorageService.instance;
    await prefs.deleteAll();

    // Get.offAllNamed(AppRoutes.login);
  }
}
