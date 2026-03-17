import 'package:equatable/equatable.dart';
import '../models/chat_model.dart';
import '../models/response/get_agents_response_model.dart';

abstract class AiChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {}

class AgentsLoaded extends AiChatState {
  final List<AgentModel> agents;
  AgentsLoaded(this.agents);

  @override
  List<Object?> get props => [agents];
}

class ChatCreated extends AiChatState {
  final String chatId;
  ChatCreated(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MessageSending extends AiChatState {
  final List<MessageModel> messages;
  final String? chatId;

  MessageSending({required this.messages, this.chatId});

  @override
  List<Object?> get props => [messages, chatId];
}

class MessageSent extends AiChatState {
  final List<MessageModel> messages;
  final String chatId;

  MessageSent({required this.messages, required this.chatId});

  @override
  List<Object?> get props => [messages, chatId];
}

class ChatLoaded extends AiChatState {
  final ChatModel chat;

  ChatLoaded(this.chat);

  @override
  List<Object?> get props => [chat];
}

class AiChatError extends AiChatState {
  final String message;
  final List<MessageModel> messages;
  final String? chatId;

  AiChatError({
    required this.message,
    this.messages = const [],
    this.chatId,
  });

  @override
  List<Object?> get props => [message, messages, chatId];
}

/// State while fetching all chats for the drawer
class ChatsLoading extends AiChatState {}

/// State when all chats have been fetched for the drawer
class ChatsLoaded extends AiChatState {
  final List<ChatSummaryModel> chats;
  ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

/// State while loading a specific chat history from the drawer
class ChatHistoryLoading extends AiChatState {}

/// State when a full chat history is loaded (from drawer click)
class ChatHistoryLoaded extends AiChatState {
  final ChatModel chat;
  ChatHistoryLoaded(this.chat);

  @override
  List<Object?> get props => [chat];
}

/// Chat has been reset — clear UI, ready for new conversation
class ChatReset extends AiChatState {}
