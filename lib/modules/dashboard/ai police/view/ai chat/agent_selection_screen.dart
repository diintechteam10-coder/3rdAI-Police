import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/ai_chat_bloc.dart';
import '../../bloc/ai_chat_event.dart';
import '../../bloc/ai_chat_state.dart';
import '../../models/response/get_agents_response_model.dart';
import '../../repository/ai_chat_repository.dart';
import 'ai_chat_screen.dart';

/// Screen to select an AI agent before starting a chat
class AgentSelectionScreen extends StatefulWidget {
  const AgentSelectionScreen({super.key});

  @override
  State<AgentSelectionScreen> createState() => _AgentSelectionScreenState();
}

class _AgentSelectionScreenState extends State<AgentSelectionScreen> {
  AgentModel? selectedAgent; // track full agent for firstMessage + name

  @override
  void initState() {
    super.initState();
    context.read<AiChatBloc>().add(LoadAgentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: Text(
          'Select AI Agent',
          style: GoogleFonts.poppins(
            color: const Color(0xFFD4AF37),
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<AiChatBloc, AiChatState>(
        builder: (context, state) {
          if (state is AiChatLoading) {
            return const _AgentListShimmer();
          }

          if (state is AgentsLoaded) {
            if (state.agents.isEmpty) {
              return Center(
                child: Text(
                  'No agents found',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.agents.length,
                    itemBuilder: (context, index) {
                      final agent = state.agents[index];
                      return _AgentCard(
                        agent: agent,
                        isSelected: selectedAgent?.id == agent.id,
                        onTap: () => setState(() => selectedAgent = agent),
                      );
                    },
                  ),
                ),
                _ContinueButton(
                  enabled: selectedAgent != null,
                  onPressed: () {
                    final agent = selectedAgent!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => AiChatBloc(AiChatRepository()),
                          child: AiChatScreen(
                            agentId: agent.id,
                            agentName: agent.displayName,
                            firstMessage: agent.firstMessage,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }

          if (state is AiChatError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style:
                        GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AiChatBloc>().add(LoadAgentsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Agent Card ─────────────────────────────────────────────────────────────

class _AgentCard extends StatelessWidget {
  final AgentModel agent;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgentCard({
    required this.agent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37).withOpacity(0.12)
              : const Color(0xFF132B4C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF2C5EA8).withOpacity(0.4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF2C5EA8),
              child: Text(
                agent.displayName.isNotEmpty ? agent.displayName[0] : 'A',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.displayName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agent.description.isNotEmpty
                        ? agent.description
                        : 'Your dedicated AI assistant for police-related tasks and information.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFD4AF37), size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Continue Button ─────────────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ContinueButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: enabled ? null : const Color(0xFF1E2A3A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: enabled ? onPressed : null,
            child: Text(
              'Start Chat',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: enabled ? Colors.black : Colors.white30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Loading ─────────────────────────────────────────────────────────

class _AgentListShimmer extends StatelessWidget {
  const _AgentListShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF132B4C),
      highlightColor: const Color(0xFF1E3A5A),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, __) => const _AgentCardShimmer(),
      ),
    );
  }
}

class _AgentCardShimmer extends StatelessWidget {
  const _AgentCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: Colors.white),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14.sp,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12.sp,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}