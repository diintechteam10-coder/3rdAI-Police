class VoiceSessionResponse {
  final bool success;
  final String message;
  final VoiceSessionData? data;

  VoiceSessionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VoiceSessionResponse.fromJson(Map<String, dynamic> json) {
    return VoiceSessionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VoiceSessionData.fromJson(json['data']) : null,
    );
  }
}

class VoiceSessionData {
  final String chatId;
  final String sessionId;

  VoiceSessionData({
    required this.chatId,
    required this.sessionId,
  });

  factory VoiceSessionData.fromJson(Map<String, dynamic> json) {
    return VoiceSessionData(
      chatId: json['chatId'] ?? '',
      sessionId: json['sessionId'] ?? '',
    );
  }
}

class VoiceProcessResponse {
  final bool success;
  final VoiceProcessData? data;

  VoiceProcessResponse({
    required this.success,
    this.data,
  });

  factory VoiceProcessResponse.fromJson(Map<String, dynamic> json) {
    return VoiceProcessResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? VoiceProcessData.fromJson(json['data']) : null,
    );
  }
}

class VoiceProcessData {
  final String transcribedText;
  final String aiResponse;
  final String audioResponse; // base64
  final String audioFormat;

  VoiceProcessData({
    required this.transcribedText,
    required this.aiResponse,
    required this.audioResponse,
    required this.audioFormat,
  });

  factory VoiceProcessData.fromJson(Map<String, dynamic> json) {
    return VoiceProcessData(
      transcribedText: json['transcribedText'] ?? '',
      aiResponse: json['aiResponse'] ?? '',
      audioResponse: json['audioResponse'] ?? '',
      audioFormat: json['audioFormat'] ?? 'wav',
    );
  }
}

// ─── WebSocket Event Models ──────────────────────────────────────────────────

abstract class VoiceEvent {
  final String type;
  VoiceEvent(this.type);
}

class TranscriptEvent extends VoiceEvent {
  final String text;
  final bool isFinal;

  TranscriptEvent({required this.text, required this.isFinal}) : super('transcript');

  factory TranscriptEvent.fromJson(Map<String, dynamic> json) {
    return TranscriptEvent(
      text: json['text'] ?? '',
      isFinal: json['isFinal'] ?? false,
    );
  }
}

class AiResponseEvent extends VoiceEvent {
  final String text;

  AiResponseEvent({required this.text}) : super('ai_response');

  factory AiResponseEvent.fromJson(Map<String, dynamic> json) {
    return AiResponseEvent(
      text: json['text'] ?? '',
    );
  }
}

class AudioChunkEvent extends VoiceEvent {
  final String audio;
  final int chunkIndex;

  AudioChunkEvent({required this.audio, required this.chunkIndex}) : super('audio_chunk');

  factory AudioChunkEvent.fromJson(Map<String, dynamic> json) {
    return AudioChunkEvent(
      audio: json['audio'] ?? '',
      chunkIndex: json['chunkIndex'] ?? 0,
    );
  }
}

class AudioCompleteEvent extends VoiceEvent {
  final int totalChunks;

  AudioCompleteEvent({required this.totalChunks}) : super('audio_complete');

  factory AudioCompleteEvent.fromJson(Map<String, dynamic> json) {
    return AudioCompleteEvent(
      totalChunks: json['totalChunks'] ?? 0,
    );
  }
}

class VoiceErrorEvent extends VoiceEvent {
  final String message;

  VoiceErrorEvent({required this.message}) : super('error');

  factory VoiceErrorEvent.fromJson(Map<String, dynamic> json) {
    return VoiceErrorEvent(
      message: json['message'] ?? 'Unknown error',
    );
  }
}

class AuthOkEvent extends VoiceEvent {
  AuthOkEvent() : super('auth_ok');
}

class UserMessageEvent extends VoiceEvent {
  final String text;

  UserMessageEvent({required this.text}) : super('user_message');

  factory UserMessageEvent.fromJson(Map<String, dynamic> json) {
    return UserMessageEvent(
      text: json['text'] ?? '',
    );
  }
}
