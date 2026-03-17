import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/snackbar_util.dart';
import '../bloc/login bloc/login_bloc.dart';
import '../bloc/login bloc/login_event.dart';
import '../bloc/login bloc/login_state.dart';
import '../../../core/routes/route_names.dart';
import '../../../widgets/modern_textfield.dart';
import '../../../../widgets/shimmer_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final AnimationController _glowController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    /// SAME glow animation as SigninMethodsScreen
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            SnackbarUtil.showError(context: context, message: state.error);
          } else if (state is LoginSuccess) {
            final isVerified =
                state.response.data?.partner?.isVerified ?? false;

            if (isVerified) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.bottomNav,
                (route) => false,
              );
            } else {
              Navigator.pushReplacementNamed(
                context,
                RouteNames.approvalPendingScreen,
              );
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (_, __) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.6),
                          radius: 1.3,
                          colors: [
                            AppColors.primary.withOpacity(
                              0.10 + _glowController.value * 0.05,
                            ),
                            AppColors.bgColor,
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0, 1.0),
                            radius: 1.2,
                            colors: [
                              AppColors.primary.withOpacity(0.06),
                              AppColors.primary.withOpacity(0.06),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// MAIN CONTENT
              Padding(
                padding: EdgeInsets.only(
                  top: padding.top,
                  left: 24,
                  right: 24,
                  bottom: padding.bottom,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height - padding.top - padding.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _AppLogo(),

                        const SizedBox(height: 30),

                        Text(
                          'Welcome Back 👋',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Login to start receiving live consultations',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),

                        const SizedBox(height: 40),

                        /// Glass Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.lightBackground.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ModernTextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                label: "Email",
                                labelColor: AppColors.white,
                                textColor: AppColors.white,
                                prefixIcon: Icons.email_outlined,
                                iconColor: AppColors.white,
                                fillColor: AppColors.bgColor,
                              ),

                              const SizedBox(height: 20),

                              ModernTextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                label: "Password",
                                labelColor: AppColors.white,
                                textColor: AppColors.white,
                                prefixIcon: Icons.lock_outline,
                                iconColor: AppColors.white,
                                fillColor: AppColors.bgColor,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: state is LoginLoading
                                      ? null
                                      : () {
                                          final email = _emailController.text
                                              .trim();
                                          final password = _passwordController
                                              .text
                                              .trim();

                                          if (email.isEmpty ||
                                              password.isEmpty) {
                                            SnackbarUtil.showError(
                                              context: context,
                                              message:
                                                  'Please enter email and password',
                                            );
                                            return;
                                          }

                                          context.read<LoginBloc>().add(
                                            LoginSubmitted(
                                              email: email,
                                              password: password,
                                            ),
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 8,
                                    shadowColor: AppColors.glowOrange
                                        .withOpacity(0.6),
                                  ),
                                  child: state is LoginLoading
                                      ? ShimmerWidgets.base(
                                          baseColor: AppColors.black.withOpacity(0.1),
                                          highlightColor: AppColors.black.withOpacity(0.3),
                                          child: Container(
                                            height: 20,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: AppColors.black,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'By continuing, you agree to our Terms & Privacy Policy',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
