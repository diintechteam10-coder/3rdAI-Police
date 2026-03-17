import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../constants/app_keys.dart';
import '../utils/logger.dart';
import '../utils/session_mannager.dart';
import 'secure_storage_service.dart';

class ApiService {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final startTime = DateTime.now();
              options.extra['startTime'] = startTime;

              final prefs = SecureStorageService.instance;
              final token = await prefs.read(AppKeys.token);

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
                appLog("🔐 Bearer Token attached");
              }

              /// 🔥 Check if clientId should be skipped
              final skipClientId = options.extra['skipClientId'] == true;

              if (!skipClientId) {
                final clientId = await prefs.read(AppKeys.clientId);

                final effectiveClientId =
                    (clientId != null && clientId.isNotEmpty)
                    ? clientId
                    : '778205';

                if (!options.path.endsWith('/$effectiveClientId')) {
                  options.path = '${options.path}/$effectiveClientId';
                }
              }

              appLog("📤 REQUEST → ${options.method} ${options.uri}");
              appLog("🔸 Headers: ${options.headers}");
              appLog("🔸 Data: ${options.data}");
              appLog("⏱️ Started at: $startTime");

              return handler.next(options);
            },

            // onRequest: (options, handler) async {
            //   final startTime = DateTime.now();
            //   options.extra['startTime'] = startTime;
            //   // Load token from SharedPreferences
            //   final prefs =  SecureStorageService.instance;
            //   final token = await prefs.read(AppKeys.token);

            //   // Add Bearer token if available
            //   if (token != null && token.isNotEmpty) {
            //     options.headers['Authorization'] = 'Bearer $token';
            //     appLog("🔐 Bearer Token attached");
            //   }

            //   // Add clientId to the end of every API URL path
            //   if (!options.path.contains('/clients/778205') && !options.path.contains('public/clients')) {
            //     final clientId = await prefs.read(AppKeys.clientId);
            //     final effectiveClientId = (clientId != null && clientId.isNotEmpty)
            //         ? clientId
            //         : '778205';
            //     if (!options.path.endsWith('/$effectiveClientId')) {
            //       options.path = '${options.path}/$effectiveClientId';
            //     }
            //   }

            //   appLog("📤 REQUEST → ${options.method} ${options.uri}");
            //   appLog("🔸 Headers: ${options.headers}");
            //   appLog("🔸 Data: ${options.data}");
            //   appLog("⏱️ Started at: $startTime");

            //   return handler.next(options);
            // },
            onResponse: (response, handler) {
              final startTime =
                  response.requestOptions.extra['startTime'] as DateTime?;
              final duration = startTime != null
                  ? DateTime.now().difference(startTime)
                  : null;
              appLog(
                "✅ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}",
              );
              appLog("📦 Response Data: ${response.data}");
              if (duration != null) {
                appLog(
                  "⏳ API Duration: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
                );
              }
              return handler.next(response);
            },

            onError: (DioException e, handler) async {
              final startTime =
                  e.requestOptions.extra['startTime'] as DateTime?;
              final duration = startTime != null
                  ? DateTime.now().difference(startTime)
                  : null;

              appLog(
                "❌ ERROR ← ${e.response?.statusCode} ${e.requestOptions.uri}",
              );
              if (duration != null) {
                appLog(
                  "⏱️ API failed after: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
                );
              }
              if (e.response?.statusCode == 401) {
                appLog("🚨 401 Unauthorized - forcing logout");
                await SessionManager.forceLogout();
                return;
              }

              if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) {
                appLog(
                  "⚠️ Timeout: The API took too long to respond (>${e.requestOptions.receiveTimeout}).",
                );

                // 🟢 Retry logic starts here
                try {
                  appLog("🔁 Retrying request once due to timeout...");
                  final retryOptions = e.requestOptions;
                  // Optional: Increase timeout for retry
                  retryOptions.connectTimeout = const Duration(seconds: 30);
                  retryOptions.receiveTimeout = const Duration(seconds: 30);

                  final response = await dio.fetch(retryOptions);
                  appLog(
                    "✅ Retry succeeded with status ${response.statusCode}",
                  );
                  return handler.resolve(response);
                } catch (retryError) {
                  appLog("❌ Retry failed too: $retryError");
                  if (retryError is DioException) {
                    appLog("🧯 Retry error message: ${retryError.message}");
                  }
                }
                // 🟢 Retry logic ends here
              } else if (e.type == DioExceptionType.cancel) {
                appLog("🚫 Request was cancelled by user or Dio.");
              }

              appLog("🧯 Message: ${e.message}");
              appLog("📦 Error Data: ${e.response?.data}");
              return handler.next(e);
            },
          ),
        );
}
