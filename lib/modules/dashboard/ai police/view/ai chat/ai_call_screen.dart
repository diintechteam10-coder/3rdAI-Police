import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../bloc/ai%20voice%20bloc/ai_voice_bloc.dart';
import '../../bloc/ai%20voice%20bloc/ai_voice_event.dart';
import '../../bloc/ai%20voice%20bloc/ai_voice_state.dart';
import '../../repository/ai_voice_repository.dart';
import '../../services/voice_socket_service.dart';
import '../../services/voice_audio_service.dart';

enum CallPhase { idle, listening, thinking, speaking }

extension CallPhaseExtension on CallPhase {
  String get label => switch (this) {
    CallPhase.idle => 'READY TO CONNECT',
    CallPhase.listening => 'LISTENING…',
    CallPhase.thinking => 'THINKING…',
    CallPhase.speaking => 'SPEAKING…',
  };

  Color get color => switch (this) {
    CallPhase.idle => AppColors.textGrey,
    CallPhase.listening => AppColors.successGreen,
    CallPhase.thinking => AppColors.primary,
    CallPhase.speaking => AppColors.gold,
  };

  Color get glowColor => switch (this) {
    CallPhase.idle => Colors.transparent,
    CallPhase.listening => AppColors.successGreen.withOpacity(0.3),
    CallPhase.thinking => AppColors.glowOrange.withOpacity(0.35),
    CallPhase.speaking => AppColors.gold.withOpacity(0.3),
  };

  String get waveLabel => switch (this) {
    CallPhase.idle => 'Standby',
    CallPhase.listening => 'Your voice',
    CallPhase.thinking => 'Processing…',
    CallPhase.speaking => 'AI speaking',
  };

  double get waveAmplitude => switch (this) {
    CallPhase.listening => 18,
    CallPhase.speaking => 12,
    _ => 4,
  };
}

class AiCallScreen extends StatefulWidget {
  const AiCallScreen({super.key});

  @override
  State<AiCallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<AiCallScreen>
    with TickerProviderStateMixin {
  // ── State ──
  bool _speakerOff = false;
  int _callSeconds = 0;

  // ── Timers ──
  late AnimationController _pulseController;
  late AnimationController _spinController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _callSeconds = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _callSeconds++);
    });
  }

  void _connect() {
    setState(() {
      _callSeconds = 0;
    });
    _startTimer();
  }

  void _disconnect() {
    setState(() {
      _callSeconds = 0;
      _speakerOff = false;
    });
  }

  void _onSpeakerTap() => setState(() {
    _speakerOff = !_speakerOff;
  });

  String get _formattedTimer {
    final m = _callSeconds ~/ 60;
    final s = _callSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AiVoiceBloc(
        repository: AiVoiceRepository(),
        socketService: VoiceSocketService(),
        audioService: VoiceAudioService(),
      ),
      child: BlocBuilder<AiVoiceBloc, AiVoiceState>(
        builder: (context, state) {
          final connected = state is AiVoiceActive;
          final muted = state is AiVoiceActive ? state.isMuted : false;

          CallPhase phase = CallPhase.idle;
          String phaseTimerStr = "";

          if (state is AiVoiceActive) {
            if (state.isSpeaking) {
              phase = CallPhase.speaking;
            } else if (state.isThinking) {
              phase = CallPhase.thinking;
            } else if (state.isUserSpeaking) {
              phase = CallPhase.listening;
            } else {
              phase = CallPhase.listening; // Default when active
            }

            // Calculate Phase Timer
            DateTime? startTime;
            if (phase == CallPhase.listening) startTime = state.userStartedSpeakingAt;
            if (phase == CallPhase.thinking) startTime = state.aiThinkingStartedAt;
            if (phase == CallPhase.speaking) startTime = state.aiSpeakingStartedAt;

            if (startTime != null) {
              final diff = DateTime.now().difference(startTime);
              final mins = diff.inMinutes
                  .remainder(60)
                  .toString()
                  .padLeft(2, '0');
              final secs = diff.inSeconds
                  .remainder(60)
                  .toString()
                  .padLeft(2, '0');
              phaseTimerStr = "$mins:$secs";
            }
          } else if (state is AiVoiceLoading) {
            phase = CallPhase.thinking;
          }

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CallCard(
                        phase: phase,
                        phaseTimer: phaseTimerStr,
                        connected: connected,
                        muted: muted,
                        speakerOff: _speakerOff,
                        timer: _formattedTimer,
                        pulseAnim: _pulseController,
                        spinAnim: _spinController,
                        waveAnim: _waveController,
                        onConnect: () {
                          if (connected) {
                            context.read<AiVoiceBloc>().add(StopCallEvent());
                            _disconnect();
                          } else {
                            context.read<AiVoiceBloc>().add(
                              StartCallEvent("nova"),
                            );
                            _connect();
                          }
                        },
                        onMute: () {
                          context.read<AiVoiceBloc>().add(ToggleMuteEvent());
                        },
                        onSpeaker: _onSpeakerTap,
                      ),

                      // Transcript Overlay
                      if (state is AiVoiceActive) ...[
                        const SizedBox(height: 20),
                        _TranscriptSection(messages: state.messages),
                      ],
                    ],
                  ),
                ),

                if (state is AiVoiceError)
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorRed.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TranscriptSection extends StatelessWidget {
  final List<ChatMessage> messages;

  const _TranscriptSection({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey, width: 1),
      ),
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[messages.length - 1 - index];
            final isUser = msg.role == "user";

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '[${msg.role.toUpperCase()}]: ${msg.text}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isUser ? AppColors.textPrimary : AppColors.gold,
                  fontWeight: isUser ? FontWeight.normal : FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CallCard extends StatelessWidget {
  const _CallCard({
    required this.phase,
    this.phaseTimer = "",
    required this.connected,
    required this.muted,
    required this.speakerOff,
    required this.timer,
    required this.pulseAnim,
    required this.spinAnim,
    required this.waveAnim,
    required this.onConnect,
    required this.onMute,
    required this.onSpeaker,
  });

  final CallPhase phase;
  final String phaseTimer;
  final bool connected;
  final bool muted;
  final bool speakerOff;
  final String timer;
  final Animation<double> pulseAnim;
  final Animation<double> spinAnim;
  final Animation<double> waveAnim;
  final VoidCallback onConnect;
  final VoidCallback onMute;
  final VoidCallback onSpeaker;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusRow(phase: phase, phaseTimer: phaseTimer),
            const SizedBox(height: 28),
            _AvatarSection(
              phase: phase,
              pulseAnim: pulseAnim,
              spinAnim: spinAnim,
            ),
            const SizedBox(height: 20),
            Text(
              'Nova AI',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              connected ? timer : '00:00',
              style: GoogleFonts.firaMono(
                fontSize: 13,
                color: AppColors.textGrey,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 24),

            // Hint when not connected
            if (!connected) ...[
              Text(
                'Press connect to start\nyour AI conversation',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Wave + Mic when connected
            if (connected) ...[
              _WaveWidget(phase: phase, muted: muted, animation: waveAnim),
              const SizedBox(height: 12),
              _MicIndicator(phase: phase, muted: muted),
              const SizedBox(height: 28),
            ],

            _ControlsRow(
              connected: connected,
              muted: muted,
              speakerOff: speakerOff,
              onConnect: onConnect,
              onMute: onMute,
              onSpeaker: onSpeaker,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.phase, this.phaseTimer = ""});
  final CallPhase phase;
  final String phaseTimer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: phase.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: phase.glowColor, blurRadius: 8, spreadRadius: 1),
            ],
          ),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            phaseTimer.isNotEmpty ? '${phase.label}: $phaseTimer' : phase.label,
            key: ValueKey('$phase$phaseTimer'),
            style: GoogleFonts.firaMono(
              fontSize: 11,
              letterSpacing: 1.6,
              color: AppColors.textGrey,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.phase,
    required this.pulseAnim,
    required this.spinAnim,
  });

  final CallPhase phase;
  final Animation<double> pulseAnim;
  final Animation<double> spinAnim;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _AnimatedRing(phase: phase, pulseAnim: pulseAnim, spinAnim: spinAnim),
          _Avatar(),
        ],
      ),
    );
  }
}

class _AnimatedRing extends StatelessWidget {
  const _AnimatedRing({
    required this.phase,
    required this.pulseAnim,
    required this.spinAnim,
  });

  final CallPhase phase;
  final Animation<double> pulseAnim;
  final Animation<double> spinAnim;

  @override
  Widget build(BuildContext context) {
    if (phase == CallPhase.idle) return const SizedBox.expand();

    Widget ring = Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: phase.color, width: 1.5),
        boxShadow: [
          BoxShadow(color: phase.glowColor, blurRadius: 20, spreadRadius: 2),
        ],
      ),
    );

    if (phase == CallPhase.listening) {
      return AnimatedBuilder(
        animation: pulseAnim,
        builder: (_, child) {
          final scale = 1.0 + pulseAnim.value * 0.06;
          return Transform.scale(scale: scale, child: child);
        },
        child: ring,
      );
    }

    if (phase == CallPhase.thinking) {
      return AnimatedBuilder(
        animation: spinAnim,
        builder: (_, child) {
          return Transform.rotate(angle: spinAnim.value * 2 * pi, child: child);
        },
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: [Colors.transparent, phase.color]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.bgColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }
    return ring;
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lightGrey, AppColors.borderGrey],
        ),
        border: Border.all(color: AppColors.borderGrey, width: 1),
      ),
      child: const Center(child: Text('🤖', style: TextStyle(fontSize: 42))),
    );
  }
}

class _WaveWidget extends StatelessWidget {
  const _WaveWidget({
    required this.phase,
    required this.muted,
    required this.animation,
  });

  final CallPhase phase;
  final bool muted;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (_, __) => CustomPaint(
            painter: _WavePainter(
              phase: phase,
              muted: muted,
              time: animation.value,
            ),
            size: const Size(double.infinity, 60),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            muted ? 'Muted' : phase.waveLabel,
            key: ValueKey('$phase$muted'),
            style: GoogleFonts.firaMono(
              fontSize: 10,
              color: AppColors.textGrey,
            ),
          ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({required this.phase, required this.muted, required this.time});

  final CallPhase phase;
  final bool muted;
  final double time; // 0..1 repeated

  @override
  void paint(Canvas canvas, Size size) {
    final t = time * 2 * pi;
    final amp = muted ? 2.0 : phase.waveAmplitude;
    final color = muted ? AppColors.errorRed : phase.color;
    final freq = phase == CallPhase.listening
        ? 2.5
        : phase == CallPhase.speaking
        ? 3.0
        : 1.5;
    final speed = phase == CallPhase.listening
        ? 1.4
        : phase == CallPhase.thinking
        ? 0.4
        : 1.0;

    _drawWave(canvas, size, t, amp, freq, speed, color, 2.0, 0.9);
    _drawWave(
      canvas,
      size,
      t,
      amp * 0.5,
      freq * 1.2,
      speed * 0.7,
      color,
      1.5,
      0.35,
      phaseShift: 0.8,
    );

    // Background rect
    final bgPaint = Paint()
      ..color = AppColors.lightGrey
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );
    // Draw bg behind waves
    canvas.drawRRect(rrect, bgPaint);
    _drawWave(canvas, size, t, amp, freq, speed, color, 2.0, 0.9);
    _drawWave(
      canvas,
      size,
      t,
      amp * 0.5,
      freq * 1.2,
      speed * 0.7,
      color,
      1.5,
      0.35,
      phaseShift: 0.8,
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double t,
    double amp,
    double freq,
    double speed,
    Color color,
    double strokeWidth,
    double opacity, {
    double phaseShift = 0,
  }) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final steps = size.width.toInt();

    for (int x = 0; x <= steps; x++) {
      final xNorm = x / steps;
      final y =
          size.height / 2 +
          sin(xNorm * pi * freq * 2 + t * speed + phaseShift) * amp +
          sin(xNorm * pi * freq * 3.1 + t * speed * 0.7 + phaseShift) *
              amp *
              0.4;

      if (x == 0)
        path.moveTo(x.toDouble(), y);
      else
        path.lineTo(x.toDouble(), y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.time != time || old.phase != phase || old.muted != muted;
}

// ─────────────────────────────────────────────
// Mic Status Indicator
// ─────────────────────────────────────────────

class _MicIndicator extends StatelessWidget {
  const _MicIndicator({required this.phase, required this.muted});
  final CallPhase phase;
  final bool muted;

  Color get _color => muted
      ? AppColors.errorRed
      : phase == CallPhase.listening
      ? AppColors.successGreen
      : AppColors.textGrey;

  String get _label => muted
      ? 'Microphone muted'
      : phase == CallPhase.listening
      ? 'Microphone active'
      : 'Microphone standby';

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: muted
            ? AppColors.errorRed.withOpacity(0.05)
            : phase == CallPhase.listening
            ? AppColors.successGreen.withOpacity(0.06)
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            muted ? Icons.mic_off_rounded : Icons.mic_rounded,
            color: _color,
            size: 16,
          ),
          const SizedBox(width: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: GoogleFonts.firaMono(
              fontSize: 10,
              color: _color,
              letterSpacing: 1.5,
            ),
            child: Text(_label.toUpperCase()),
          ),
          const SizedBox(width: 10),
          _MicLevelBars(
            active: phase == CallPhase.listening && !muted,
            color: _color,
          ),
        ],
      ),
    );
  }
}

class _MicLevelBars extends StatefulWidget {
  const _MicLevelBars({required this.active, required this.color});
  final bool active;
  final Color color;

  @override
  State<_MicLevelBars> createState() => _MicLevelBarsState();
}

class _MicLevelBarsState extends State<_MicLevelBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        final heights = [
          8.0 + (widget.active ? sin(t * pi) * 8 : 2),
          8.0 + (widget.active ? sin(t * pi + 1.1) * 6 : 1),
          8.0 + (widget.active ? sin(t * pi + 0.5) * 10 : 2),
          8.0 + (widget.active ? sin(t * pi + 1.8) * 7 : 1),
          8.0 + (widget.active ? sin(t * pi + 0.8) * 9 : 2),
        ];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            5,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                width: 3,
                height: heights[i],
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ControlsRow extends StatelessWidget {
  const _ControlsRow({
    required this.connected,
    required this.muted,
    required this.speakerOff,
    required this.onConnect,
    required this.onMute,
    required this.onSpeaker,
  });

  final bool connected;
  final bool muted;
  final bool speakerOff;
  final VoidCallback onConnect;
  final VoidCallback onMute;
  final VoidCallback onSpeaker;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (connected) ...[
          _IconControl(
            icon: muted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: 'Mute',
            active: muted,
            activeColor: AppColors.errorRed,
            onTap: onMute,
          ),
          const SizedBox(width: 20),
        ],

        _MainCallButton(connected: connected, onTap: onConnect),

        if (connected) ...[
          const SizedBox(width: 20),
          _IconControl(
            icon: speakerOff
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            label: 'Speaker',
            active: speakerOff,
            activeColor: AppColors.errorRed,
            onTap: onSpeaker,
          ),
        ],
      ],
    );
  }
}

class _MainCallButton extends StatefulWidget {
  const _MainCallButton({required this.connected, required this.onTap});
  final bool connected;
  final VoidCallback onTap;

  @override
  State<_MainCallButton> createState() => _MainCallButtonState();
}

class _MainCallButtonState extends State<_MainCallButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnect = !widget.connected;
    final bgColor = isConnect ? AppColors.successGreen : AppColors.errorRed;
    final glowColor = isConnect
        ? AppColors.successGreen.withOpacity(0.3)
        : AppColors.errorRed.withOpacity(0.3);
    final icon = isConnect ? Icons.call_rounded : Icons.call_end_rounded;
    final iconColor = isConnect ? const Color(0xFF001A10) : Colors.white;
    final label = isConnect ? 'Connect' : 'End Call';

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (_, child) {
            final pulse = isConnect ? _pulseCtrl.value : 0.0;
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 20 + pulse * 12,
                    spreadRadius: pulse * 4,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 72,
              height: 72,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
              child: Icon(icon, color: iconColor, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.firaMono(
            fontSize: 10,
            color: AppColors.textGrey,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _IconControl extends StatelessWidget {
  const _IconControl({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? activeColor.withOpacity(0.1)
                  : AppColors.lightGrey,
              border: Border.all(
                color: active
                    ? activeColor.withOpacity(0.35)
                    : AppColors.borderGrey,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: active ? activeColor : AppColors.textGrey,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.firaMono(
            fontSize: 10,
            color: AppColors.textGrey,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
