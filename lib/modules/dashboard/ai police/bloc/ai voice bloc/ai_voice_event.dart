import 'package:equatable/equatable.dart';
enum VoiceEventType {
  authOk,
  deepgramConnected,
  started,
  aiResponse,
  audioChunk,
  audioComplete,
  transcript,
  userMessage,
  stopped,
  error,
}
abstract class AiVoiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartCallEvent extends AiVoiceEvent {
  final String agentId;
  StartCallEvent(this.agentId);

  @override
  List<Object?> get props => [agentId];
}

class StopCallEvent extends AiVoiceEvent {}

class ToggleMuteEvent extends AiVoiceEvent {}

class InternalSocketEvent extends AiVoiceEvent {
  final dynamic event;
  InternalSocketEvent(this.event);

  @override
  List<Object?> get props => [event];
}
