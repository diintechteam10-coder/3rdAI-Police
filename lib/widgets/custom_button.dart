import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;

  final bool withShadow;
  final Color shadowColor;
  final double shadowBlur;
  final double shadowSpread;

  final double? width;
  final double? height;

  /// ✅ NEW: Loader Flag
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    this.onTap,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.borderRadius = 16,
    this.fontSize = 16,
    this.withShadow = true,
    this.shadowColor = AppColors.primary,
    this.shadowBlur = 8,
    this.shadowSpread = 1,
    this.width,
    this.height,

    /// ✅ Default loader = false
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return GestureDetector(
      onTap: isLoading ? null : onTap, // ✅ Disable tap while loading
      child: Container(
        width: width ?? double.infinity,
        height: height ?? screenHeight * 0.065,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: withShadow
              ? [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.4),
                    blurRadius: shadowBlur,
                    spreadRadius: shadowSpread,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
