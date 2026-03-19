import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAgentsEvent extends AiChatEvent {}

class CreateChatEvent extends AiChatEvent {
  final String agentId;
  CreateChatEvent({required this.agentId});

  @override
  List<Object?> get props => [agentId];
}

class SendMessageEvent extends AiChatEvent {
  final String message;
  final String? chatId;
  final String agentId;

  SendMessageEvent({
    required this.message,
    required this.agentId,
    this.chatId,
  });

  @override
  List<Object?> get props => [message, chatId, agentId];
}

class LoadChatHistoryEvent extends AiChatEvent {
  final String chatId;
  LoadChatHistoryEvent({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

/// Fetch all chats for the drawer
class LoadAllChatsEvent extends AiChatEvent {}

/// Reset the current chat (UI only — no API call)
class ResetChatEvent extends AiChatEvent {}

class SelectAgentEvent extends AiChatEvent {
  final String agentId;
  SelectAgentEvent({required this.agentId});

  @override
  List<Object?> get props => [agentId];
}
