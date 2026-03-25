import 'package:equatable/equatable.dart';

class ChatMessage {
  final String role; // "user" | "ai"
  final String text;

  const ChatMessage({
    required this.role,
    required this.text,
  });
}

abstract class AiVoiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiVoiceInitial extends AiVoiceState {}

class AiVoiceLoading extends AiVoiceState {}

class AiVoiceActive extends AiVoiceState {
  final String chatId;
  final String sessionId;

  final bool isMuted;
  final bool isSpeaking;
  final bool isUserSpeaking;
  final bool isThinking;
 
  final List<ChatMessage> messages;

  /// 🔥 TIMING STATES
  final DateTime? userStartedSpeakingAt;
  final DateTime? aiThinkingStartedAt;
  final DateTime? aiSpeakingStartedAt;

  AiVoiceActive({
    required this.chatId,
    required this.sessionId,
    this.isMuted = false,
    this.isSpeaking = false,
    this.isUserSpeaking = false,
    this.isThinking = false,
    this.messages = const [],
    this.userStartedSpeakingAt,
    this.aiThinkingStartedAt,
    this.aiSpeakingStartedAt,
  });

  AiVoiceActive copyWith({
    bool? isMuted,
    bool? isSpeaking,
    bool? isUserSpeaking,
    bool? isThinking,
    List<ChatMessage>? messages,
    DateTime? userStartedSpeakingAt,
    DateTime? aiThinkingStartedAt,
    DateTime? aiSpeakingStartedAt,
  }) {
    return AiVoiceActive(
      chatId: chatId,
      sessionId: sessionId,
      isMuted: isMuted ?? this.isMuted,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isUserSpeaking: isUserSpeaking ?? this.isUserSpeaking,
      isThinking: isThinking ?? this.isThinking,
      messages: messages ?? this.messages,
      userStartedSpeakingAt: userStartedSpeakingAt ?? this.userStartedSpeakingAt,
      aiThinkingStartedAt: aiThinkingStartedAt ?? this.aiThinkingStartedAt,
      aiSpeakingStartedAt: aiSpeakingStartedAt ?? this.aiSpeakingStartedAt,
    );
  }

  @override
  List<Object?> get props => [
        chatId,
        sessionId,
        isMuted,
        isSpeaking,
        isUserSpeaking,
        isThinking,
        messages,
        userStartedSpeakingAt,
        aiThinkingStartedAt,
        aiSpeakingStartedAt,
      ];
}

class AiVoiceError extends AiVoiceState {
  final String message;
  AiVoiceError(this.message);

  @override
  List<Object?> get props => [message];
}

class AiVoiceIdle extends AiVoiceState {}