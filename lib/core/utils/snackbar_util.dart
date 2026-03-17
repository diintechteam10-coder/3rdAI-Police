import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SnackbarUtil {
  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      title: 'Success',
      backgroundColor: AppColors.successGreen,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      title: 'Error',
      backgroundColor: AppColors.errorRed,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required String title,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}
