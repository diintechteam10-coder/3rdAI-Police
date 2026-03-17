import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmerWidgets {
  static Widget base({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFF132B4C),
      highlightColor: highlightColor ?? const Color(0xFF1E3A5A),
      child: child,
    );
  }

  static Widget box({
    double width = double.infinity,
    double height = 20,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static Widget circle({double radius = 20}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Shimmer for Profile Screen Loading
  static Widget profileShimmer() {
    return base(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              box(width: 100, height: 28),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    circle(radius: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          box(width: 150, height: 20),
                          const SizedBox(height: 8),
                          box(width: 100, height: 16),
                          const SizedBox(height: 16),
                          box(width: double.infinity, height: 1),
                          const SizedBox(height: 8),
                          box(width: 120, height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              box(width: 100, height: 24),
              const SizedBox(height: 16),
              ...List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: box(width: double.infinity, height: 60, borderRadius: 14),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Placeholder for Alert Details Header
  static Widget alertDetailsShimmer() {
    return base(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                box(width: 180, height: 24),
                box(width: 100, height: 32, borderRadius: 30),
              ],
            ),
            const SizedBox(height: 20),
            box(width: double.infinity, height: 80, borderRadius: 16),
            const SizedBox(height: 20),
            box(width: 150, height: 20),
            const SizedBox(height: 10),
            box(width: double.infinity, height: 100, borderRadius: 16),
            const SizedBox(height: 20),
            box(width: 150, height: 20),
            const SizedBox(height: 12),
            Row(
              children: [
                box(width: 120, height: 120, borderRadius: 16),
                const SizedBox(width: 12),
                box(width: 120, height: 120, borderRadius: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
