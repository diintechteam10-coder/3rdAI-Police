import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/ai chat bloc/ai_chat_bloc.dart';
import '../repository/ai_chat_repository.dart';
import 'ai chat/agent_selection_screen.dart';

class AiPoliceScreen extends StatelessWidget {
  const AiPoliceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A), // Dark navy blue top
              Color(0xFF1B2A41), // Lighter navy bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. TOP HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Text(
                      'AI Police',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. TITLE SECTION
              Text(
                'AI POLICE ASSISTANCE',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37), // Gold
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 1,
                    color: const Color(0xFFD4AF37).withOpacity(0.4),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Your AI Police Helper',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFFB0BEC5), // Light grey
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 1,
                    color: const Color(0xFFD4AF37).withOpacity(0.4),
                  ),
                ],
              ),

              const Expanded(flex: 1, child: SizedBox()),
              // Character Image
              Image.asset(
                'assets/images/ai_police.png', // High-quality 3D character placeholder with transparent background
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),

              const Expanded(flex: 1, child: SizedBox()),

              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Talk Button (Active)
                    Column(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFD4AF37),
                                Color(0xFFAA8000),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 4,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(38),
                              onTap: () {
                                // Voice talk: navigate to agent selection
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => AiChatBloc(AiChatRepository()),
                                      child: const AgentSelectionScreen(isTalk: true),
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Talk',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD4AF37),
                            shadows: [
                              Shadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 40),

                    // Chat Button (Inactive)
                    Column(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(38),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) =>
                                          AiChatBloc(AiChatRepository()),
                                      child: const AgentSelectionScreen(isTalk: false),
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: Color(0xFF90A4AE),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Chat',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF90A4AE),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
