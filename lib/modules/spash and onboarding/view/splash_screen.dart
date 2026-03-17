import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _logoFloat;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _logoFloat = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          Navigator.pushReplacementNamed(
            context,
            state.nextRoute,
            arguments: state.arguments,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF020617),
                Color(0xFF111827),
              ],
            ),
          ),
          child: Stack(
            children: [

              const _BackgroundGlow(),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      AnimatedBuilder(
                        animation: _logoFloat,
                        builder: (_, child) {
                          return Transform.translate(
                            offset: Offset(0, _logoFloat.value),
                            child: child,
                          );
                        },
                        child: const _GlassLogo(),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "AI POLICE",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Next Generation Policing",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 50),

                      const _ModernLoader(),

                      const SizedBox(height: 20),

                      const Text(
                        "Initializing system...",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// BACKGROUND GLOW
////////////////////////////////////////////////////////////

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [

        Align(
          alignment: Alignment.topLeft,
          child: _GlowCircle(
            size: 260,
            color: Colors.deepOrange,
            opacity: .35,
          ),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: _GlowCircle(
            size: 320,
            color: Colors.blue,
            opacity: .30,
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: _GlowCircle(
            size: 200,
            color: Colors.amber,
            opacity: .15,
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 120,
        sigmaY: 120,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// GLASS LOGO CARD
////////////////////////////////////////////////////////////

class _GlassLogo extends StatelessWidget {
  const _GlassLogo();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(.15),
                Colors.white.withOpacity(.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(.2),
            ),
          ),
          child: Image.asset(
            "assets/images/logo.png",
            width: 60,
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// MODERN LOADER
////////////////////////////////////////////////////////////

class _ModernLoader extends StatefulWidget {
  const _ModernLoader();

  @override
  State<_ModernLoader> createState() => _ModernLoaderState();
}

class _ModernLoaderState extends State<_ModernLoader>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {

        return Container(
          width: 170,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(.08),
          ),
          child: Align(
            alignment: Alignment(
              controller.value * 2 - 1,
              0,
            ),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Colors.deepOrange,
                    Colors.blue,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}