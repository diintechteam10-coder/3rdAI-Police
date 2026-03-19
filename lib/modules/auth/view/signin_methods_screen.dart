import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_names.dart';
import '../bloc/signin methods bloc/signin_methods_bloc.dart';
import '../bloc/signin methods bloc/signin_methods_event.dart';
import '../bloc/signin methods bloc/signin_methods_state.dart';
import '../bloc/google auth bloc/google_auth_bloc.dart';
import '../bloc/google auth bloc/google_auth_state.dart';
import '../view/google_signin_button.dart';
import '../../../core/utils/snackbar_util.dart';
import 'registration view/otp_type.dart';

class SigninMethodsScreen extends StatefulWidget {
  const SigninMethodsScreen({super.key});

  @override
  State<SigninMethodsScreen> createState() => _SigninMethodsScreenState();
}

class _SigninMethodsScreenState extends State<SigninMethodsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _glowController;

  String _displayedText = "";
  final String _fullText = "Intelligence Beyond Vision";

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _startTyping();
  }

  void _startTyping() async {
    for (int i = 0; i < _fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted) return;
      setState(() {
        _displayedText = _fullText.substring(0, i + 1);
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SigninMethodsBloc, SigninMethodsState>(
          listener: (context, state) {
            if (state is NavigateToLogin) {
              Navigator.pushNamed(context, RouteNames.loginScreen);
            }
            if (state is NavigateToSignup) {
              Navigator.pushNamed(context, RouteNames.sendOtpScreen);
            }
          },
        ),
        BlocListener<GoogleSignInBloc, GoogleSignInState>(
          listener: (context, state) {
            if (state is GoogleSignInSuccess) {
              if (state.response.registrationComplete) {
                // If already registered, go to home
                Navigator.pushReplacementNamed(context, RouteNames.bottomNav);
              } else {
                // If not registered, continue registration flow
                Navigator.pushNamed(
                  context,
                  RouteNames.sendOtpScreen,
                  arguments: {
                    'type': OtpType.mobile,
                    'email': state.response.data.email,
                  },
                );
              }
            } else if (state is GoogleSignInError) {
              SnackbarUtil.showError(context: context, message: state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Stack(
          children: [
            /// 🔥 Subtle Premium Glow Background
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (_, __) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.5),
                        radius: 1.2,
                        colors: [
                          AppColors.primary.withOpacity(
                            0.08 + _glowController.value * 0.05,
                          ),
                          AppColors.bgColor,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// CENTER CONTENT
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🔥 Stable Premium Orb (NO animation)
                  Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          AppColors.lightPrimary,
                          AppColors.primary,
                          AppColors.darkPrimary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.glowOrange.withOpacity(0.6),
                          blurRadius: 35,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      _displayedText,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SigninMethodsBloc, SigninMethodsState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: state.showInfo
                            ? Container(
                                key: const ValueKey("info"),
                                width: 320,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBackground.withOpacity(
                                    0.8,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                  ),
                                ),
                                child: const Text(
                                  "Tap Continue with Google for the fastest secure access.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -25,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.75),
                            blurRadius: 50,
                            spreadRadius: 15,
                            offset: const Offset(0, 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground.withOpacity(0.95),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GoogleSignInButton(),

                        const SizedBox(height: 16),

                        /// SIGN UP
                        _OutlineButton(
                          text: "Sign Up",
                          onTap: () {
                            context.read<SigninMethodsBloc>().add(
                              SignupRequested(),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// LOG IN
                        _OutlineButton(
                          text: "Log In",
                          onTap: () {
                            context.read<SigninMethodsBloc>().add(
                              LoginRequested(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlineButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
