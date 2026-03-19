// import 'dart:async';
// import 'dart:convert';
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


// DateTime? _lastSent;

// bool _canSend() {
//   final now = DateTime.now();
//   if (_lastSent == null || now.difference(_lastSent!) > const Duration(milliseconds: 120)) {
//     _lastSent = now;
//     return true;
//   }
//   return false;
// }

// bool _isValidAudio(String base64Chunk) {
//   final bytes = base64Decode(base64Chunk);

//   int sum = 0;
//   for (int i = 0; i < bytes.length; i++) {
//     sum += bytes[i].abs();
//   }

//   final avg = sum / bytes.length;

//   return avg > 20;
// }
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
//       // If it's a partial transcript, we can show it live
//       // If it's final, we'll wait for user_message to 'commit' it or just handle it here
//       emit(s.copyWith(userTranscript: voiceEvent.text));
//     }
//     else if (voiceEvent is UserMessageEvent) {
//       // user_message is often the definitive final transcript
//       emit(s.copyWith(userTranscript: voiceEvent.text));
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

// await _audioService.startRecording((base64Chunk) {
//   final currentState = state;

//   if (currentState is AiVoiceActive) {
//     if (!currentState.isMuted && !currentState.isSpeaking) {

//       // 🔥 FILTER + THROTTLE
//       if (_isValidAudio(base64Chunk) && _canSend()) {
//         _socketService.sendAudio(base64Chunk);
//       }
//     }
//   }
// });

//       // /// 🎤 RESTART MIC (LOOP)
//       // await _audioService.startRecording((base64Chunk) {
//       //   final currentState = state;
//       //   if (currentState is AiVoiceActive) {
//       //     if (!currentState.isMuted && !currentState.isSpeaking) {
//       //       _socketService.sendAudio(base64Chunk);
//       //     }
//       //   }
//       // });
    
    
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


import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_keys.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../repository/ai_voice_repository.dart';
import '../../services/voice_socket_service.dart';
import '../../services/voice_audio_service.dart';
import '../../models/response/voice_response_models.dart';
import 'ai_voice_event.dart';
import 'ai_voice_state.dart';

class AiVoiceBloc extends Bloc<AiVoiceEvent, AiVoiceState> {
  final AiVoiceRepository _repository;
  final VoiceSocketService _socketService;
  final VoiceAudioService _audioService;

  StreamSubscription? _socketSub;
  Completer<void>? _authCompleter;

  DateTime? _lastSent;

  AiVoiceBloc({
    required AiVoiceRepository repository,
    required VoiceSocketService socketService,
    required VoiceAudioService audioService,
  })  : _repository = repository,
        _socketService = socketService,
        _audioService = audioService,
        super(AiVoiceInitial()) {

    on<StartCallEvent>(_onStartCall);
    on<StopCallEvent>(_onStopCall);
    on<ToggleMuteEvent>(_onToggleMute);
    on<InternalSocketEvent>(_onSocketEvent);

    print("🏗️ AiVoiceBloc Initialized");

    _socketSub = _socketService.events.listen((event) {
      add(InternalSocketEvent(event));
    });

    /// 🔥 Silence detection
    _audioService.onSilenceDetected = () {
      print("🤫 USER STOPPED SPEAKING");
      _socketService.sendAudioEnd();
      
      final current = state;
      if (current is AiVoiceActive) {
        // Trigger thinking phase timestamp locally if UserMessageEvent is delayed
        add(InternalSocketEvent(UserMessageEvent(text: ''))); 
      }
    };
  }
  bool _isValidAudio(String base64Chunk) {
    final bytes = base64Decode(base64Chunk);
    int sum = 0;
    for (var b in bytes) {
      sum += b.abs();
    }
    final avg = sum / bytes.length;
    return avg > 10;
  }

  bool _canSend() {
    final now = DateTime.now();
    if (_lastSent == null ||
        now.difference(_lastSent!) > const Duration(milliseconds: 120)) {
      _lastSent = now;
      return true;
    }
    return false;
  }

  Future<void> _onStartCall(StartCallEvent event, Emitter<AiVoiceState> emit) async {
    print("📞 [BLOC] Starting Call for agent: ${event.agentId}");
    emit(AiVoiceLoading());

    final sessionRes = await _repository.startVoiceSession(chatId: 'new');

    final chatId = sessionRes.data!.chatId;
    final sessionId = sessionRes.data!.sessionId;
    print("🆔 [BLOC] Session: $sessionId, Chat: $chatId");

    final token = await SecureStorageService.instance.read(AppKeys.token);
      final agentId = await SecureStorageService.instance.read(AppKeys.agentId);
      final firstMsg = await SecureStorageService.instance.read(AppKeys.agentFirstMessage);

    _authCompleter = Completer<void>();
    await _socketService.connect(token!);
    await _authCompleter!.future;

    _socketService.startSession(
       chatId,
      agentId: agentId,
      firstMessage: firstMsg,
    );

    emit(AiVoiceActive(chatId: chatId, sessionId: sessionId));
  }

  Future<void> _onSocketEvent(InternalSocketEvent event, Emitter<AiVoiceState> emit) async {
    final voiceEvent = event.event;

    if (voiceEvent is AuthOkEvent) {
      _authCompleter?.complete();
      return;
    }

    if (state is! AiVoiceActive) return;
    final s = state as AiVoiceActive;

    /// 🧑 USER MESSAGE (Partial)
    if (voiceEvent is TranscriptEvent) {
      final updated = List<ChatMessage>.from(s.messages);
      DateTime? userStartTime = s.userStartedSpeakingAt ?? DateTime.now();

      if (updated.isNotEmpty && updated.last.role == "user") {
        updated[updated.length - 1] =
            ChatMessage(role: "user", text: voiceEvent.text);
      } else {
        updated.add(ChatMessage(role: "user", text: voiceEvent.text));
      }

      emit(s.copyWith(
        messages: updated,
        userStartedSpeakingAt: userStartTime,
        aiThinkingStartedAt: null, 
        aiSpeakingStartedAt: null,
      ));
    }

    /// 🧑 USER MESSAGE (Final)
    else if (voiceEvent is UserMessageEvent) {
      final updated = List<ChatMessage>.from(s.messages);

      if (updated.isNotEmpty && updated.last.role == "user") {
        updated[updated.length - 1] =
            ChatMessage(role: "user", text: voiceEvent.text.isNotEmpty ? voiceEvent.text : updated.last.text);
      } else if (voiceEvent.text.isNotEmpty) {
        updated.add(ChatMessage(role: "user", text: voiceEvent.text));
      }

      emit(s.copyWith(
        messages: updated,
        aiThinkingStartedAt: s.aiThinkingStartedAt ?? DateTime.now(),
      ));
    }

    /// 🤖 AI TEXT
    else if (voiceEvent is AiResponseEvent) {
      final updated = List<ChatMessage>.from(s.messages);
      DateTime? aiStartTime = s.aiSpeakingStartedAt ?? DateTime.now();

      if (updated.isNotEmpty && updated.last.role == "ai") {
        updated[updated.length - 1] =
            ChatMessage(role: "ai", text: voiceEvent.text);
      } else {
        updated.add(ChatMessage(role: "ai", text: voiceEvent.text));
      }

      emit(s.copyWith(
        messages: updated,
        aiThinkingStartedAt: null, // Done thinking
        aiSpeakingStartedAt: aiStartTime,
      ));
    }

    else if (voiceEvent is AudioChunkEvent) {
      _audioService.addAudioChunk(voiceEvent.audio);
      if (s.aiSpeakingStartedAt == null) {
        emit(s.copyWith(
          aiThinkingStartedAt: null,
          aiSpeakingStartedAt: DateTime.now(),
        ));
      }
    }

    /// 🔥 LOOP
    else if (voiceEvent is AudioCompleteEvent) {
      await _audioService.stopRecording();

      emit(s.copyWith(isSpeaking: true));

      await _audioService.playBufferedAudio();
      _audioService.clearAudioBuffer();

      emit(s.copyWith(isSpeaking: false));

      await _audioService.startRecording((chunk) {
        final current = state;
        if (current is AiVoiceActive) {
          if (!current.isMuted && !current.isSpeaking) {
            if (_isValidAudio(chunk) && _canSend()) {
              _socketService.sendAudio(chunk);
            }
          }
        }
      });
    }
  }

  Future<void> _onStopCall(StopCallEvent event, Emitter<AiVoiceState> emit) async {
    print("🛑 [BLOC] Stopping Call...");
    await _audioService.stopRecording();
    await _audioService.stopPlayback();
    _socketService.disconnect();
    emit(AiVoiceIdle());
  }

  void _onToggleMute(ToggleMuteEvent event, Emitter<AiVoiceState> emit) {
    if (state is AiVoiceActive) {
      final s = state as AiVoiceActive;
      emit(s.copyWith(isMuted: !s.isMuted));
    }
  }

  @override
  Future<void> close() {
    _socketSub?.cancel();
    _socketService.dispose();
    _audioService.dispose();
    return super.close();
  }
}

// class AiVoiceBloc extends Bloc<AiVoiceEvent, AiVoiceState> {
//   final VoiceSocketService _socket;
//   final VoiceAudioService _audio;

//   StreamSubscription? _sub;

//   DateTime? _lastSent;

//   AiVoiceBloc(this._socket, this._audio) : super(AiVoiceInitial()) {
//     on<StartCallEvent>(_start);
//     on<StopCallEvent>(_stop);
//     on<_InternalEvent>(_handle);

//     _sub = _socket.events.listen((e) {
//       add(_InternalEvent(e));
//     });

//     _audio.onSilenceDetected = () {
//       _socket.sendAudioEnd();
//     };
//   }

//   bool _canSend() {
//     final now = DateTime.now();
//     if (_lastSent == null ||
//         now.difference(_lastSent!) > const Duration(milliseconds: 120)) {
//       _lastSent = now;
//       return true;
//     }
//     return false;
//   }

//   Future<void> _start(StartCallEvent e, Emitter emit) async {
//     emit(AiVoiceLoading());

//     await _socket.connect(e.token);
//     _socket.startSession("new");

//     await _startRecording();

//     emit(AiVoiceActive());
//   }

//   Future<void> _startRecording() async {
//     await _audio.startRecording((chunk) {
//       if (_canSend()) {
//         _socket.sendAudio(chunk);
//       }
//     });
//   }

//   Future<void> _handle(_InternalEvent e, Emitter emit) async {
//     final data = e.data;

//     if (data['type'] == 'audio_chunk') {
//       _audio.addAudioChunk(data['audio']);
//     }

//     if (data['type'] == 'audio_complete') {
//       await _audio.stopRecording();

//       emit(AiVoiceSpeaking());

//       await _audio.playBufferedAudio();

//       emit(AiVoiceListening());

//       await _startRecording();
//     }
//   }

//   Future<void> _stop(StopCallEvent e, Emitter emit) async {
//     await Future.wait([
//       _audio.stopRecording(),
//       _audio.stopPlayback(),
//     ]);

//     _socket.disconnect();

//     emit(AiVoiceIdle());
//   }

//   @override
//   Future<void> close() {
//     _sub?.cancel();
//     _socket.dispose();
//     _audio.dispose();
//     return super.close();
//   }
// }