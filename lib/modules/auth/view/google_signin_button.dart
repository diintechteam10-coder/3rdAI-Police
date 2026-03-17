import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/google auth bloc/google_auth_bloc.dart';
import '../bloc/google auth bloc/google_auth_event.dart';
import '../bloc/google auth bloc/google_auth_state.dart';

class GoogleSignInButton extends StatelessWidget {
  final double height;
  final double width;

  const GoogleSignInButton({
    super.key,
    this.height = 55,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
      builder: (context, state) {
        final isLoading = state is GoogleAuthLoading;

        return SizedBox(
          height: height,
          width: width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: const BorderSide(color: AppColors.borderGrey),
              ),
              elevation: 2,
            ),
            onPressed: isLoading
                ? null
                : () {
                    context.read<GoogleAuthBloc>().add(
                      const GoogleSignInRequested(),
                    );
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                else ...[
                  Image.asset(
                    'assets/icons/google.png', // Assuming user has this asset; fallback to icon if not
                    height: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.g_mobiledata,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
