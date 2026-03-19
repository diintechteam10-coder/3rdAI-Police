import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_names.dart';
import '../../bloc/signup bloc/verify_otp/verify_otp_bloc.dart';
import '../../bloc/signup bloc/verify_otp/verify_otp_event.dart';
import '../../bloc/signup bloc/verify_otp/verify_otp_state.dart';
import 'otp_type.dart';

class OtpVerificationScreen extends StatefulWidget {
  final OtpType type;
  final String input;
  final String email;
  final OtpChannel? channel;

  const OtpVerificationScreen({
    super.key,
    required this.type,
    required this.input,
    this.email = '',
    this.channel,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
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

    context.read<VerifyOtpBloc>().add(
      VerifyOtpInitialized(
        type: widget.type,
        input: widget.input,
        email: widget.email,
        channel: widget.channel,
      ),
    );
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
    _canResend = false;
    _secondsRemaining = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
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
    final isEmail = widget.type == OtpType.email;

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F111A), Color(0xFF1A1F2E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🔐 ICON
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    isEmail ? "Verify Email OTP" : "Verify Mobile OTP",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "OTP sent to ${widget.input}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60),
                  ),

                  const SizedBox(height: 40),

                  /// 🔢 OTP BOXES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => _otpBox(index)),
                  ),

                  const SizedBox(height: 10),
                  _resendOtpSection(),

                  /// 🔥 VERIFY BUTTON

                  const SizedBox(height: 30),
                  _verifyButton(isEmail),

                  /// RESEND
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _resendOtpSection() {
    return BlocListener<VerifyOtpBloc, VerifyOtpState>(
      listenWhen: (previous, current) =>
          previous.resendLoading != current.resendLoading ||
          previous.resendSuccess != current.resendSuccess,
      listener: (context, state) {
        if (state.resendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.resendMessage ?? "OTP Resent Successfully"),
              backgroundColor: Colors.green,
            ),
          );
          _startTimer(); // 🔁 timer restart after resend
        } else if (state.resendMessage != null && !state.resendLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.resendMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
        builder: (context, state) {
          return Column(
            children: [
              /// ⏱️ TIMER TEXT
              Text(
                _canResend
                    ? "Didn’t receive OTP?"
                    : "Resend OTP in ${_formatTime(_secondsRemaining)}",
                style: TextStyle(
                  color: _canResend ? Colors.white70 : Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              /// 🔁 RESEND BUTTON / LOADER
              if (_canResend)
                state.resendLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF7B61FF),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          context
                              .read<VerifyOtpBloc>()
                              .add(ResendOtpRequested());
                        },
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Color(0xFF7B61FF),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
            ],
          );
        },
      ),
    );
  }
  Widget _verifyButton(bool isEmail) {
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        if (state.isSuccess) {
          if (isEmail) {
            Navigator.pushReplacementNamed(
              context,
              RouteNames.sendOtpScreen,
              arguments: {'type': OtpType.mobile, 'email': state.input},
            );
          } else {
            Navigator.pushNamed(
              context,
              RouteNames.completeProfileScreen,
              arguments: {'email': state.email},
            );
          }
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isEnabled = otp.length == 6 && !state.isLoading;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isEnabled ? 1 : 0.6,
          child: GestureDetector(
            onTap: isEnabled
                ? () {
                    context.read<VerifyOtpBloc>().add(
                      VerifyOtpSubmitted(otp: otp),
                    );
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFF5B4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.6),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: state.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Verify OTP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
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
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
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
