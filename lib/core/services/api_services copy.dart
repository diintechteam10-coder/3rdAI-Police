// // import 'package:dio/dio.dart';
// // import '../constants/api_constants.dart';
// // import '../constants/app_keys.dart';
// // import '../utils/logger.dart';
// // import '../utils/session_mannager.dart';
// // import 'shared_preferences.dart';

// // class ApiService {
// //   static final Dio dio =
// //       Dio(
// //           BaseOptions(
// //             baseUrl: ApiConstants.baseUrl,
// //             connectTimeout: const Duration(seconds: 15),
// //             receiveTimeout: const Duration(seconds: 15),
// //             headers: {
// //               "Accept": "application/json",
// //               "Content-Type": "application/json",
// //             },
// //           ),
// //         )
// //         ..interceptors.add(
// //           InterceptorsWrapper(
// //             onRequest: (options, handler) async {
// //               final startTime = DateTime.now();
// //               options.extra['startTime'] = startTime;
// //               // Load token from SharedPreferences
// //               final prefs = await SharedPreferencesService.getInstance();
// //               final token = prefs.getString(AppKeys.token);

// //               // Add Bearer token if available
// //               if (token != null && token.isNotEmpty) {
// //                 options.headers['Authorization'] = 'Bearer $token';
// //                 appLog("🔐 Bearer Token attached");
// //               }

// //               appLog("📤 REQUEST → ${options.method} ${options.uri}");
// //               appLog("🔸 Headers: ${options.headers}");
// //               appLog("🔸 Data: ${options.data}");
// //               appLog("⏱️ Started at: $startTime");

// //               return handler.next(options);
// //             },

// //             onResponse: (response, handler) {
// //               final startTime =
// //                   response.requestOptions.extra['startTime'] as DateTime?;
// //               final duration = startTime != null
// //                   ? DateTime.now().difference(startTime)
// //                   : null;
// //               appLog(
// //                 "✅ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}",
// //               );
// //               appLog("📦 Response Data: ${response.data}");
// //               if (duration != null) {
// //                 appLog(
// //                   "⏳ API Duration: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
// //                 );
// //               }
// //               return handler.next(response);
// //             },

// //             onError: (DioException e, handler) async {
// //               final startTime =
// //                   e.requestOptions.extra['startTime'] as DateTime?;
// //               final duration = startTime != null
// //                   ? DateTime.now().difference(startTime)
// //                   : null;

// //               appLog(
// //                 "❌ ERROR ← ${e.response?.statusCode} ${e.requestOptions.uri}",
// //               );
// //               if (duration != null) {
// //                 appLog(
// //                   "⏱️ API failed after: ${duration.inMilliseconds} ms (${duration.inSeconds}s)",
// //                 );
// //               }
// //               if (e.response?.statusCode == 401) {
// //                 appLog("🚨 401 Unauthorized - forcing logout");
// //                 await SessionManager.forceLogout();
// //                 return;
// //               }

// //               if (e.type == DioExceptionType.connectionTimeout ||
// //                   e.type == DioExceptionType.receiveTimeout) {
// //                 appLog(
// //                   "⚠️ Timeout: The API took too long to respond (>${e.requestOptions.receiveTimeout}).",
// //                 );

// //                 // 🟢 Retry logic starts here
// //                 try {
// //                   appLog("🔁 Retrying request once due to timeout...");
// //                   final retryOptions = e.requestOptions;
// //                   // Optional: Increase timeout for retry
// //                   retryOptions.connectTimeout = const Duration(seconds: 30);
// //                   retryOptions.receiveTimeout = const Duration(seconds: 30);

// //                   final response = await dio.fetch(retryOptions);
// //                   appLog(
// //                     "✅ Retry succeeded with status ${response.statusCode}",
// //                   );
// //                   return handler.resolve(response);
// //                 } catch (retryError) {
// //                   appLog("❌ Retry failed too: $retryError");
// //                   if (retryError is DioException) {
// //                     appLog("🧯 Retry error message: ${retryError.message}");
// //                   }
// //                 }
// //                 // 🟢 Retry logic ends here
// //               } else if (e.type == DioExceptionType.cancel) {
// //                 appLog("🚫 Request was cancelled by user or Dio.");
// //               }

// //               appLog("🧯 Message: ${e.message}");
// //               appLog("📦 Error Data: ${e.response?.data}");
// //               return handler.next(e);
// //             },
// //           ),
// //         );
// // }



// import 'dart:async';
// import 'package:dio/dio.dart';
// import '../constants/api_constants.dart';
// import '../utils/logger.dart';
// import '../utils/session_mannager.dart';

// class ApiService {
//   static final FlutterSecureStorage _storage =
//       const FlutterSecureStorage();

//   static final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/json",
//       },
//     ),
//   );

//   static bool _isRefreshing = false;
//   static Completer<void>? _refreshCompleter;

//   static void init() {
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final startTime = DateTime.now();
//           options.extra['startTime'] = startTime;

//           final token = await _storage.read(key: 'accessToken');

//           if (token != null) {
//             options.headers['Authorization'] = 'Bearer $token';
//             appLog("🔐 Bearer token attached");
//           }

//           appLog("📤 REQUEST → ${options.method} ${options.uri}");
//           appLog("🔸 Headers: ${options.headers}");
//           appLog("🔸 Data: ${options.data}");
//           appLog("⏱️ Started at: $startTime");

//           return handler.next(options);
//         },

//         onResponse: (response, handler) {
//           final startTime =
//               response.requestOptions.extra['startTime'] as DateTime?;

//           final duration = startTime != null
//               ? DateTime.now().difference(startTime)
//               : null;

//           appLog(
//               "✅ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}");
//           appLog("📦 Response Data: ${response.data}");

//           if (duration != null) {
//             appLog(
//                 "⏳ API Duration: ${duration.inMilliseconds} ms (${duration.inSeconds}s)");
//           }

//           return handler.next(response);
//         },

//         onError: (DioException e, handler) async {
//           final startTime =
//               e.requestOptions.extra['startTime'] as DateTime?;

//           final duration = startTime != null
//               ? DateTime.now().difference(startTime)
//               : null;

//           appLog(
//               "❌ ERROR ← ${e.response?.statusCode} ${e.requestOptions.uri}");

//           if (duration != null) {
//             appLog(
//                 "⏱️ Failed after: ${duration.inMilliseconds} ms (${duration.inSeconds}s)");
//           }

//           appLog("🧯 Message: ${e.message}");
//           appLog("📦 Error Data: ${e.response?.data}");

//           // =========================
//           // 🔥 REFRESH TOKEN LOGIC
//           // =========================

//           if (e.response?.statusCode == 401 &&
//               e.requestOptions.path != ApiConstants.refreshToken) {

//             appLog("🚨 401 detected. Attempting token refresh...");

//             try {
//               await _handleRefreshToken();

//               final newToken =
//                   await _storage.read(key: 'accessToken');

//               appLog("🔄 Retrying original request...");

//               final options = e.requestOptions;
//               options.headers['Authorization'] =
//                   'Bearer $newToken';

//               final response = await dio.fetch(options);

//               appLog(
//                   "✅ Retry Success ← ${response.statusCode}");

//               return handler.resolve(response);

//             } catch (refreshError) {
//               appLog(
//                   "❌ Refresh failed. Forcing logout...");

//               await SessionManager.forceLogout();

//               return handler.next(e);
//             }
//           }

//           return handler.next(e);
//         },
//       ),
//     );
//   }

//   static Future<void> _handleRefreshToken() async {
//     if (_isRefreshing) {
//       appLog("⏳ Refresh already in progress. Waiting...");
//       return _refreshCompleter?.future;
//     }

//     _isRefreshing = true;
//     _refreshCompleter = Completer<void>();

//     try {
//       appLog("🔁 Calling refresh token API...");

//       final response =
//           await dio.post(ApiConstants.refreshToken);

//       final newAccessToken =
//           response.data['accessToken'];

//       appLog("✅ New AccessToken received");

//       await _storage.write(
//         key: 'accessToken',
//         value: newAccessToken,
//       );

//       dio.options.headers['Authorization'] =
//           'Bearer $newAccessToken';

//       appLog("🔐 AccessToken updated in storage");

//       _refreshCompleter?.complete();

//     } catch (e) {
//       appLog("❌ Refresh API failed: $e");

//       _refreshCompleter?.completeError(e);
//       rethrow;

//     } finally {
//       _isRefreshing = false;
//     }
//   }
// }