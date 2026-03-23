import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../bloc/verify_reset_otp/verify_reset_otp_bloc.dart';
import '../../bloc/verify_reset_otp/verify_reset_otp_event.dart';
import '../../bloc/verify_reset_otp/verify_reset_otp_state.dart';
import '../../bloc/resend_reset_otp/resend_reset_otp_bloc.dart';
import '../../bloc/resend_reset_otp/resend_reset_otp_event.dart';
import '../../bloc/resend_reset_otp/resend_reset_otp_state.dart';

class VerifyResetPasswordEmailOtpScreen extends StatefulWidget {
  final String email;

  const VerifyResetPasswordEmailOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyResetPasswordEmailOtpScreen> createState() => _VerifyResetPasswordEmailOtpScreenState();
}

class _VerifyResetPasswordEmailOtpScreenState extends State<VerifyResetPasswordEmailOtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 59;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 59;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  String get otp => controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerifyResetOtpBloc, VerifyResetOtpState>(
            listener: (context, state) {
              if (state is VerifyResetOtpSuccess) {
                SnackbarUtil.showSuccess(
                  context: context,
                  message: state.message,
                );
                Navigator.pushNamed(
                  context,
                  RouteNames.resetPasswordScreen,
                  arguments: {
                    'email': widget.email,
                    'resetToken': state.resetToken,
                  },
                );
              } else if (state is VerifyResetOtpError) {
                SnackbarUtil.showError(
                  context: context,
                  message: state.error,
                );
              }
            },
          ),
          BlocListener<ResendResetOtpBloc, ResendResetOtpState>(
            listener: (context, state) {
              if (state is ResendResetOtpSuccess) {
                SnackbarUtil.showSuccess(
                  context: context,
                  message: state.message,
                );
                _startTimer();
              } else if (state is ResendResetOtpError) {
                SnackbarUtil.showError(
                  context: context,
                  message: state.error,
                );
              }
            },
          ),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.lock_person_outlined,
                    size: 45,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter the 6-digit code sent to\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _otpBox(index)),
                ),
                const SizedBox(height: 30),
                _resendOtpSection(),
                const SizedBox(height: 50),
                _verifyButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resendOtpSection() {
    return BlocBuilder<ResendResetOtpBloc, ResendResetOtpState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              _canResend
                  ? "Didn’t receive OTP?"
                  : "Resend OTP in ${_formatTime(_secondsRemaining)}",
              style: TextStyle(
                color: _canResend ? Colors.white70 : Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            if (_canResend)
              TextButton(
                onPressed: state is ResendResetOtpLoading
                    ? null
                    : () {
                        context.read<ResendResetOtpBloc>().add(
                              ResendResetOtpSubmitted(email: widget.email),
                            );
                      },
                child: state is ResendResetOtpLoading
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
              ),
          ],
        );
      },
    );
  }

  Widget _verifyButton() {
    return BlocBuilder<VerifyResetOtpBloc, VerifyResetOtpState>(
      builder: (context, state) {
        final isEnabled = otp.length == 6 && state is! VerifyResetOtpLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    context.read<VerifyResetOtpBloc>().add(
                          VerifyResetOtpSubmitted(
                            email: widget.email,
                            otp: otp,
                          ),
                        );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
            ),
            child: state is VerifyResetOtpLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 48,
      height: 60,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}
