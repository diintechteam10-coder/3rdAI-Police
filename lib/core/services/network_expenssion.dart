import 'package:dio/dio.dart';

class NetworkExceptions {
  static String getErrorMessage(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return "Connection timeout, please try again.";
  } else if (error.type == DioExceptionType.badResponse) {
    final statusCode = error.response?.statusCode ?? 0;

    // 🔥 Extract backend message
    final responseData = error.response?.data;
    final backendMessage =
        responseData is Map ? responseData['message'] : null;

    switch (statusCode) {
      case 400:
        return backendMessage ?? "Bad Request";
      case 401:
        return backendMessage ?? "Unauthorized, please login again";
      case 403:
        return backendMessage ?? "Forbidden request";
      case 404:
        return backendMessage ?? "Not Found";
      case 500:
        return backendMessage ?? "Internal Server Error";
      default:
        return backendMessage ?? "Server error: $statusCode";
    }
  } else if (error.type == DioExceptionType.cancel) {
    return "Request was cancelled";
  } else {
    return "Unexpected error occurred";
  }
}
 
  // static String getErrorMessage(DioException error) {
  //   if (error.type == DioExceptionType.connectionTimeout ||
  //       error.type == DioExceptionType.sendTimeout ||
  //       error.type == DioExceptionType.receiveTimeout) {
  //     return "Connection timeout, please try again.";
  //   } else if (error.type == DioExceptionType.badResponse) {
  //     final statusCode = error.response?.statusCode ?? 0;
  //     switch (statusCode) {
  //       case 400:
  //         return "Bad Request";
  //       case 401:
  //         return "Unauthorized, please login again";
  //       case 403:
  //         return "Forbidden request";
  //       case 404:
  //         return "Not Found";
  //       case 500:
  //         return "Internal Server Error";
  //       default:
  //         return "Server error: $statusCode";
  //     }
  //   } else if (error.type == DioExceptionType.cancel) {
  //     return "Request was cancelled";
  //   } else {
  //     return "Unexpected error occurred";
  //   }
  // }
}