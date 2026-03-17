import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.white,
      error: AppColors.errorRed,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.lightText,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.lightText,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.lightText,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: AppColors.textSecondary,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkBackground,
      error: AppColors.errorRed,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.darkText,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: AppColors.darkText,
      ),
    ),
  );
}