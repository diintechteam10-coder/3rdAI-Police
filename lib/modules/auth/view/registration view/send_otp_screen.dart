import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../widgets/modern_textfield.dart';
import '../../bloc/signup bloc/send_otp/send_otp_bloc.dart';
import '../../bloc/signup bloc/send_otp/send_otp_event.dart';
import '../../bloc/signup bloc/send_otp/send_otp_state.dart';
import '../../../../widgets/shimmer_widgets.dart';

import 'otp_type.dart';

class SendOtpScreen extends StatefulWidget {
  final OtpType type;
  final String email;

  const SendOtpScreen({super.key, required this.type, this.email = ''});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 🔥 Initialize Bloc with type and email
    context.read<SendOtpBloc>().add(
      SendOtpInitialized(type: widget.type, email: widget.email),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendOtpBloc, SendOtpState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pushNamed(
            context,
            RouteNames.verifyOtpScreen,
            arguments: {
              'type': state.type,
              'input': controller.text,
              'email': state
                  .email, // Add email so it can be passed to VerifyPhoneOtpRequestModel
            },
          );
        }
      },
      child: Scaffold(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<SendOtpBloc, SendOtpState>(
                  builder: (context, state) {
                    final isEmail = state.type == OtpType.email;

                    return Column(
                      children: [
                        /// 🔥 ICON
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                          child: Icon(
                            isEmail
                                ? Icons.mark_email_unread_outlined
                                : Icons.phone_android_rounded,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// TITLE
                        Text(
                          isEmail ? "Verify Your Email" : "Verify Your Mobile",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          isEmail
                              ? "We will send an OTP to your email address"
                              : "We will send an OTP to your mobile number",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 35),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Column(
                            children: [
                              ModernTextField(
                                controller: controller,
                                hint: isEmail
                                    ? "Enter your email"
                                    : "Enter mobile number",
                                keyboardType: isEmail
                                    ? TextInputType.emailAddress
                                    : TextInputType.phone,
                                label: isEmail
                                    ? "Email Address"
                                    : "Mobile Number",
                              ),

                              if (isEmail) ...[
                                const SizedBox(height: 20),
                                ModernTextField(
                                  controller: passwordController,
                                  hint: "Enter your password",
                                  label: "Password",
                                  obscureText: true,
                                ),
                              ],

                              const SizedBox(height: 24),

                              if (!isEmail)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _modernChannelButton(
                                          context,
                                        label: "WhatsApp",
                                        selected:
                                            state.channel ==
                                            OtpChannel.whatsapp,
                                        channel: OtpChannel.whatsapp,
                                   
                                     
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _modernChannelButton(
                                         context,
                                        label: "SMS",
                                        selected:
                                            state.channel == OtpChannel.sms,
                                        channel: OtpChannel.sms,
                                      ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: state.isLoading
                                      ? null
                                      : () {
                                          context.read<SendOtpBloc>().add(
                                            SendOtpSubmitted(
                                              email: controller.text.trim(),
                                              password: passwordController.text
                                                  .trim(),
                                            ),
                                          );
                                        },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFF4A40FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: state.isLoading
                                          ? ShimmerWidgets.base(
                                              baseColor: Colors.white10,
                                              highlightColor: Colors.white24,
                                              child: Container(
                                                height: 20,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              "Send OTP",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernChannelButton(
    BuildContext context, {
    required String label,
    required bool selected,
    required OtpChannel channel,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<SendOtpBloc>().add(
          SendOtpChannelChanged(channel: channel),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? const Color(0xFF6C63FF)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: selected
                ? const Color(0xFF6C63FF)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
