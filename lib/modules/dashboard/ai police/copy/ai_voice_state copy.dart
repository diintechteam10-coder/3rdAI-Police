// // import 'package:equatable/equatable.dart';
// // import '../../models/response/voice_response_models.dart';

// // abstract class AiVoiceState extends Equatable {
// //   @override
// //   List<Object?> get props => [];
// // }

// // class AiVoiceInitial extends AiVoiceState {}

// // class AiVoiceLoading extends AiVoiceState {}

// // class AiVoiceActive extends AiVoiceState {
// //   final String chatId;
// //   final String sessionId;
// //   final String userTranscript;
// //   final String aiResponse;
// //   final bool isMuted;
// //   final bool isSpeaking; // AI is currently playing audio
// //   final List<VoiceEvent> eventHistory;

// //   AiVoiceActive({
// //     required this.chatId,
// //     required this.sessionId,
// //     this.userTranscript = '',
// //     this.aiResponse = '',
// //     this.isMuted = false,
// //     this.isSpeaking = false,
// //     this.eventHistory = const [],
// //   });

// //   AiVoiceActive copyWith({
// //     String? userTranscript,
// //     String? aiResponse,
// //     bool? isMuted,
// //     bool? isSpeaking,
// //     List<VoiceEvent>? eventHistory,
// //   }) {
// //     return AiVoiceActive(
// //       chatId: chatId,
// //       sessionId: sessionId,
// //       userTranscript: userTranscript ?? this.userTranscript,
// //       aiResponse: aiResponse ?? this.aiResponse,
// //       isMuted: isMuted ?? this.isMuted,
// //       isSpeaking: isSpeaking ?? this.isSpeaking,
// //       eventHistory: eventHistory ?? this.eventHistory,
// //     );
// //   }

// //   @override
// //   List<Object?> get props => [
// //         chatId,
// //         sessionId,
// //         userTranscript,
// //         aiResponse,
// //         isMuted,
// //         isSpeaking,
// //         eventHistory,
// //       ];
// // }

// // class AiVoiceError extends AiVoiceState {
// //   final String message;
// //   AiVoiceError(this.message);

// //   @override
// //   List<Object?> get props => [message];
// // }

// // class AiVoiceIdle extends AiVoiceState {}


// import 'package:equatable/equatable.dart';
// import '../../models/response/voice_response_models.dart';

// abstract class AiVoiceState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class AiVoiceInitial extends AiVoiceState {}

// class AiVoiceLoading extends AiVoiceState {}

// class AiVoiceActive extends AiVoiceState {
//   final String chatId;
//   final String sessionId;

//   final String userTranscript;
//   final String aiResponse;

//   final bool isMuted;
//   final bool isSpeaking;

//   /// 🔥 NEW STATES
//   final bool isListening;
//   final bool isProcessing;

//   final DateTime? lastUserSpeechTime;
//   final DateTime? aiStartTime;

//   final List<VoiceEvent> eventHistory;

//   AiVoiceActive({
//     required this.chatId,
//     required this.sessionId,
//     this.userTranscript = '',
//     this.aiResponse = '',
//     this.isMuted = false,
//     this.isSpeaking = false,
//     this.isListening = false,
//     this.isProcessing = false,
//     this.lastUserSpeechTime,
//     this.aiStartTime,
//     this.eventHistory = const [],
//   });

//   AiVoiceActive copyWith({
//     String? userTranscript,
//     String? aiResponse,
//     bool? isMuted,
//     bool? isSpeaking,
//     bool? isListening,
//     bool? isProcessing,
//     DateTime? lastUserSpeechTime,
//     DateTime? aiStartTime,
//     List<VoiceEvent>? eventHistory,
//   }) {
//     return AiVoiceActive(
//       chatId: chatId,
//       sessionId: sessionId,
//       userTranscript: userTranscript ?? this.userTranscript,
//       aiResponse: aiResponse ?? this.aiResponse,
//       isMuted: isMuted ?? this.isMuted,
//       isSpeaking: isSpeaking ?? this.isSpeaking,
//       isListening: isListening ?? this.isListening,
//       isProcessing: isProcessing ?? this.isProcessing,
//       lastUserSpeechTime: lastUserSpeechTime ?? this.lastUserSpeechTime,
//       aiStartTime: aiStartTime ?? this.aiStartTime,
//       eventHistory: eventHistory ?? this.eventHistory,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         chatId,
//         sessionId,
//         userTranscript,
//         aiResponse,
//         isMuted,
//         isSpeaking,
//         isListening,
//         isProcessing,
//         lastUserSpeechTime,
//         aiStartTime,
//         eventHistory,
//       ];
// }

// class AiVoiceError extends AiVoiceState {
//   final String message;
//   AiVoiceError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class AiVoiceIdle extends AiVoiceState {}