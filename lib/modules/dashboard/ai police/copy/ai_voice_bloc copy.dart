// // import 'dart:async';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../../../../../core/constants/app_keys.dart';
// // import '../../../../../core/services/secure_storage_service.dart';
// // import '../../repository/ai_voice_repository.dart';
// // import '../../services/voice_socket_service.dart';
// // import '../../services/voice_audio_service.dart';
// // import '../../models/response/voice_response_models.dart';
// // import 'ai_voice_event.dart';
// // import 'ai_voice_state.dart';

// // class AiVoiceBloc extends Bloc<AiVoiceEvent, AiVoiceState> {
// //   final AiVoiceRepository _repository;
// //   final VoiceSocketService _socketService;
// //   final VoiceAudioService _audioService;
  
// //   StreamSubscription? _socketSub;
// //   Completer<void>? _authCompleter;

// //   AiVoiceBloc({
// //     required AiVoiceRepository repository,
// //     required VoiceSocketService socketService,
// //     required VoiceAudioService audioService,
// //   })  : _repository = repository,
// //         _socketService = socketService,
// //         _audioService = audioService,
// //         super(AiVoiceInitial()) {
// //     on<StartCallEvent>(_onStartCall);
// //     on<StopCallEvent>(_onStopCall);
// //     on<ToggleMuteEvent>(_onToggleMute);
// //     on<InternalSocketEvent>(_onSocketEvent);

// //     // Listen to socket events
// //     _socketSub = _socketService.events.listen((event) {
// //       add(InternalSocketEvent(event));
// //     });
// //   }

// //   Future<void> _onStartCall(StartCallEvent event, Emitter<AiVoiceState> emit) async {
// //     emit(AiVoiceLoading());
// //     try {
// //       // 1. Health Check
// //       final isHealthy = await _repository.checkHealth();
// //       if (!isHealthy) {
// //         print("⚠️ Voice Server Health Check Failed");
// //         emit(AiVoiceError("Voice server is currently unavailable."));
// //         return;
// //       }

// //       // 2. Start Session (REST)
// //       final sessionRes = await _repository.startVoiceSession(chatId: 'new');
// //       if (!sessionRes.success || sessionRes.data == null) {
// //         emit(AiVoiceError(sessionRes.message));
// //         return;
// //       }

// //       final chatId = sessionRes.data!.chatId;
// //       final sessionId = sessionRes.data!.sessionId;

// //       // 3. Connect WebSocket & Authenticate
// //       final token = await SecureStorageService.instance.read(AppKeys.token);
// //       if (token == null) {
// //         emit(AiVoiceError("Authentication token not found."));
// //         return;
// //       }

// //       _authCompleter = Completer<void>();
// //       await _socketService.connect(token);
      
// //       print("⏳ Waiting for WebSocket authentication...");
// //       await _authCompleter!.future.timeout(const Duration(seconds: 10), onTimeout: () {
// //         throw TimeoutException("WebSocket authentication timed out");
// //       });

// //       // 4. Start Session (WS)
// //       final agentId = await SecureStorageService.instance.read(AppKeys.agentId);
// //       final firstMsg = await SecureStorageService.instance.read(AppKeys.agentFirstMessage);
      
// //       _socketService.startSession(
// //         chatId, 
// //         agentId: agentId,
// //         firstMessage: firstMsg,
// //       );

// //       // 5. Start Recording (Sending voice to server)
// //       // The microphone is opened HERE
// //       await _audioService.startRecording((base64Chunk) {
// //         if (state is AiVoiceActive) {
// //           final s = state as AiVoiceActive;
// //           // Only send user audio if NOT muted AND AI is NOT speaking
// //           if (!s.isMuted && !s.isSpeaking) {
// //             _socketService.sendAudio(base64Chunk);
// //           }
// //         }
// //       });

// //       emit(AiVoiceActive(
// //         chatId: chatId,
// //         sessionId: sessionId,
// //       ));
// //     } catch (e) {
// //       print("❌ Error in _onStartCall: $e");
// //       emit(AiVoiceError(e.toString()));
// //       add(StopCallEvent()); // Cleanup on failure
// //     }
// //   }

// //   Future<void> _onStopCall(StopCallEvent event, Emitter<AiVoiceState> emit) async {
// //     try {
// //       // The microphone is closed HERE
// //       await _audioService.stopRecording();
// //       await _audioService.stopPlayback();
// //       _audioService.clearAudioBuffer();
      
// //       _socketService.stopSession();
// //       await _socketService.disconnect();
      
// //       _authCompleter = null;
// //       emit(AiVoiceIdle());
// //     } catch (e) {
// //       print("❌ Error in _onStopCall: $e");
// //     }
// //   }

// //   void _onToggleMute(ToggleMuteEvent event, Emitter<AiVoiceState> emit) {
// //     if (state is AiVoiceActive) {
// //       final s = state as AiVoiceActive;
// //       emit(s.copyWith(isMuted: !s.isMuted));
// //       print("🎤 Microphone ${!s.isMuted ? 'MUTED' : 'UNMUTED'}");
// //     }
// //   }

// //   Future<void> _onSocketEvent(InternalSocketEvent event, Emitter<AiVoiceState> emit) async {
// //     final voiceEvent = event.event;

// //     if (voiceEvent is AuthOkEvent) {
// //       _authCompleter?.complete();
// //       return;
// //     }

// //     if (state is! AiVoiceActive) return;
// //     final s = state as AiVoiceActive;

// //     if (voiceEvent is TranscriptEvent) {
// //       emit(s.copyWith(userTranscript: voiceEvent.text));
// //     } 
// //     else if (voiceEvent is AiResponseEvent) {
// //       emit(s.copyWith(aiResponse: voiceEvent.text));
// //     } 
// //     else if (voiceEvent is AudioChunkEvent) {
// //       _audioService.addAudioChunk(voiceEvent.audio);
// //     } 
// //     else if (voiceEvent is AudioCompleteEvent) {
// //   emit(s.copyWith(isSpeaking: true));
// //   print("🔊 AI started speaking...");
  
// //   await _audioService.playBufferedAudio();
// //   _audioService.clearAudioBuffer();

// //   emit(s.copyWith(isSpeaking: false));
// //   print("🎤 Restarting mic after AI...");

// //   // 🔥 ADD THIS (MOST IMPORTANT FIX)
// //   await _audioService.startRecording((base64Chunk) {
// //     final currentState = state;
// //     if (currentState is AiVoiceActive) {
// //       if (!currentState.isMuted && !currentState.isSpeaking) {
// //         _socketService.sendAudio(base64Chunk);
// //       }
// //     }
// //   });
// //   //   else if (voiceEvent is AudioCompleteEvent) {
// //   //     emit(s.copyWith(isSpeaking: true));
// //   //     print("🔊 AI started speaking...");
      
// //   //     await _audioService.playBufferedAudio();
// //   //     _audioService.clearAudioBuffer();
      
// //   //     emit(s.copyWith(isSpeaking: false));
// //   //     print("🎤 AI finished. Checking mic status...");

// //   //     // 🔥 Restart recording if it was stopped by silence detection
// //   //     if (!_audioService.isRecording) {
// //   //       print("🎤 Restarting mic for user response...");
// //   //       await _audioService.startRecording((base64Chunk) {
// //   //         if (state is AiVoiceActive) {
// //   //           final currentState = state as AiVoiceActive;
// //   //           if (!currentState.isMuted && !currentState.isSpeaking) {
// //   //             _socketService.sendAudio(base64Chunk);
// //   //           }
// //   //         }
// //   //       });
// //   //     }
// //   // //  
  
  
// //     } 
// //     else if (voiceEvent is VoiceErrorEvent) {
// //       print("❌ VOICESOCKET ERROR: ${voiceEvent.message}");
// //       if (voiceEvent.message.contains("Unauthorized")) {
// //          emit(AiVoiceError("Authentication failed on voice server."));
// //          add(StopCallEvent());
// //       }
// //     }
// //   }

// //   @override
// //   Future<void> close() {
// //     _socketSub?.cancel();
// //     _socketService.dispose();
// //     _audioService.dispose();
// //     return super.close();
// //   }
// // }




// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../core/constants/app_keys.dart';
// import '../../../../../core/services/secure_storage_service.dart';
// import '../../repository/ai_voice_repository.dart';
// import '../../services/voice_socket_service.dart';
// import '../../services/voice_audio_service.dart';
// import '../../models/response/voice_response_models.dart';
// import 'ai_voice_event.dart';
// import 'ai_voice_state.dart';

// class AiVoiceBloc extends Bloc<AiVoiceEvent, AiVoiceState> {
//   final AiVoiceRepository _repository;
//   final VoiceSocketService _socketService;
//   final VoiceAudioService _audioService;
  
//   StreamSubscription? _socketSub;
//   Completer<void>? _authCompleter;

//   AiVoiceBloc({
//     required AiVoiceRepository repository,
//     required VoiceSocketService socketService,
//     required VoiceAudioService audioService,
//   })  : _repository = repository,
//         _socketService = socketService,
//         _audioService = audioService,
//         super(AiVoiceInitial()) {

//     on<StartCallEvent>(_onStartCall);
//     on<StopCallEvent>(_onStopCall);
//     on<ToggleMuteEvent>(_onToggleMute);
//     on<InternalSocketEvent>(_onSocketEvent);

//     /// 🔥 SOCKET LISTENER
//     _socketSub = _socketService.events.listen((event) {
//       add(InternalSocketEvent(event));
//     });

//     /// 🔥 SILENCE DETECTION → BACKEND SIGNAL
//     _audioService.onSilenceDetected = () {
//       print("🤫 USER STOPPED SPEAKING");
//       _socketService.sendAudioEnd(); // 🔥 IMPORTANT
//     };
//   }

//   Future<void> _onStartCall(StartCallEvent event, Emitter<AiVoiceState> emit) async {
//     emit(AiVoiceLoading());
//     try {
//       final isHealthy = await _repository.checkHealth();
//       if (!isHealthy) {
//         emit(AiVoiceError("Voice server unavailable"));
//         return;
//       }

//       final sessionRes = await _repository.startVoiceSession(chatId: 'new');
//       if (!sessionRes.success || sessionRes.data == null) {
//         emit(AiVoiceError(sessionRes.message));
//         return;
//       }

//       final chatId = sessionRes.data!.chatId;
//       final sessionId = sessionRes.data!.sessionId;

//       final token = await SecureStorageService.instance.read(AppKeys.token);
//       if (token == null) {
//         emit(AiVoiceError("Token not found"));
//         return;
//       }

//       _authCompleter = Completer<void>();
//       await _socketService.connect(token);

//       await _authCompleter!.future;

//       final agentId = await SecureStorageService.instance.read(AppKeys.agentId);
//       final firstMsg = await SecureStorageService.instance.read(AppKeys.agentFirstMessage);

//       _socketService.startSession(
//         chatId,
//         agentId: agentId,
//         firstMessage: firstMsg,
//       );

//       /// 🎤 START MIC FIRST TIME
//       await _audioService.startRecording((base64Chunk) {
//         if (state is AiVoiceActive) {
//           final s = state as AiVoiceActive;
//           if (!s.isMuted && !s.isSpeaking) {
//             _socketService.sendAudio(base64Chunk);
//           }
//         }
//       });

//       emit(AiVoiceActive(
//         chatId: chatId,
//         sessionId: sessionId,
//       ));
//     } catch (e) {
//       emit(AiVoiceError(e.toString()));
//       add(StopCallEvent());
//     }
//   }

//   Future<void> _onStopCall(StopCallEvent event, Emitter<AiVoiceState> emit) async {
//     await _audioService.stopRecording();
//     await _audioService.stopPlayback();
//     _audioService.clearAudioBuffer();

//     _socketService.stopSession();
//     await _socketService.disconnect();

//     emit(AiVoiceIdle());
//   }

//   void _onToggleMute(ToggleMuteEvent event, Emitter<AiVoiceState> emit) {
//     if (state is AiVoiceActive) {
//       final s = state as AiVoiceActive;
//       emit(s.copyWith(isMuted: !s.isMuted));
//     }
//   }

//   Future<void> _onSocketEvent(InternalSocketEvent event, Emitter<AiVoiceState> emit) async {
//     final voiceEvent = event.event;

//     if (voiceEvent is AuthOkEvent) {
//       _authCompleter?.complete();
//       return;
//     }

//     if (state is! AiVoiceActive) return;
//     final s = state as AiVoiceActive;

//     if (voiceEvent is TranscriptEvent) {
//       emit(s.copyWith(
//         userTranscript: s.userTranscript + " " + voiceEvent.text,
//       ));
//     }

//     else if (voiceEvent is AiResponseEvent) {
//       emit(s.copyWith(aiResponse: voiceEvent.text));
//     }

//     else if (voiceEvent is AudioChunkEvent) {
//       _audioService.addAudioChunk(voiceEvent.audio);
//     }

//     /// 🔥 MAIN FIX AREA
//     else if (voiceEvent is AudioCompleteEvent) {

//       // 🛑 STOP MIC BEFORE AI SPEAKS
//       await _audioService.stopRecording();

//       emit(s.copyWith(isSpeaking: true));
//       print("🔊 AI speaking...");

//       await _audioService.playBufferedAudio();
//       _audioService.clearAudioBuffer();

//       emit(s.copyWith(isSpeaking: false));
//       print("🎤 Restarting mic...");

//       /// 🎤 RESTART MIC (LOOP)
//       await _audioService.startRecording((base64Chunk) {
//         final currentState = state;
//         if (currentState is AiVoiceActive) {
//           if (!currentState.isMuted && !currentState.isSpeaking) {
//             _socketService.sendAudio(base64Chunk);
//           }
//         }
//       });
//     }

//     else if (voiceEvent is VoiceErrorEvent) {
//       emit(AiVoiceError(voiceEvent.message));
//       add(StopCallEvent());
//     }
//   }

//   @override
//   Future<void> close() {
//     _socketSub?.cancel();
//     _socketService.dispose();
//     _audioService.dispose();
//     return super.close();
//   }
// }