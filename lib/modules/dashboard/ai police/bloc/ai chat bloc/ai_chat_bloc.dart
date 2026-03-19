import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/ai_chat_repository.dart';
import '../../models/chat_model.dart';
import 'ai_chat_event.dart';
import 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final AiChatRepository _repository;

  AiChatBloc(this._repository) : super(AiChatInitial()) {
    on<LoadAgentsEvent>(_onLoadAgents);
    on<CreateChatEvent>(_onCreateChat);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<LoadAllChatsEvent>(_onLoadAllChats);
    on<ResetChatEvent>(_onResetChat);
  }

  // ─── Load agents ─────────────────────────────────────────────────────────────
  Future<void> _onLoadAgents(LoadAgentsEvent event, Emitter<AiChatState> emit) async {
    emit(AiChatLoading());
    try {
      final result = await _repository.getAgents();
      if (result.success) {
        emit(AgentsLoaded(result.data));
      } else {
        emit(AiChatError(message: 'Failed to load agents'));
      }
    } catch (e) {
      emit(AiChatError(message: e.toString()));
    }
  }

  // ─── Create chat ─────────────────────────────────────────────────────────────
  Future<void> _onCreateChat(CreateChatEvent event, Emitter<AiChatState> emit) async {
    emit(AiChatLoading());
    try {
      final result = await _repository.createChat(event.agentId);
      if (result.success && result.chatId != null) {
        emit(ChatCreated(result.chatId!));
      } else {
        emit(AiChatError(message: 'Failed to create chat'));
      }
    } catch (e) {
      emit(AiChatError(message: e.toString()));
    }
  }

  // ─── Send message (auto-creates chat on first message) ───────────────────────
  Future<void> _onSendMessage(SendMessageEvent event, Emitter<AiChatState> emit) async {
    List<MessageModel> currentMessages = _getMessagesFromState(state);
    String? currentChatId = _getChatIdFromState(state);

    // Optimistic user message
    final optimisticMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: event.message,
    );
    currentMessages = [...currentMessages, optimisticMsg];
    emit(MessageSending(messages: currentMessages, chatId: currentChatId));

    try {
      if (currentChatId == null) {
        final chatResult = await _repository.createChat(event.agentId);
        if (!chatResult.success || chatResult.chatId == null) {
          emit(AiChatError(message: 'Could not start chat.', messages: currentMessages));
          return;
        }
        currentChatId = chatResult.chatId;
      }

      final result = await _repository.sendMessage(currentChatId!, event.message);
      if (result.success) {
        final updated = [...currentMessages];
        if (result.assistantMessage != null) updated.add(result.assistantMessage!);
        emit(MessageSent(messages: updated, chatId: currentChatId));
      } else {
        emit(AiChatError(message: 'Failed to send message.', messages: currentMessages, chatId: currentChatId));
      }
    } catch (e) {
      emit(AiChatError(message: e.toString(), messages: currentMessages, chatId: currentChatId));
    }
  }

  // ─── Load single chat history (from drawer click) ────────────────────────────
  Future<void> _onLoadChatHistory(LoadChatHistoryEvent event, Emitter<AiChatState> emit) async {
    emit(ChatHistoryLoading());
    try {
      debugPrint('📂 [AiChat] Loading chat history for chatId: ${event.chatId}');
      final result = await _repository.getChatHistory(event.chatId);
      if (result.success && result.chat != null) {
        debugPrint('✅ [AiChat] Chat history loaded — ${result.chat!.messages.length} messages');
        emit(ChatHistoryLoaded(result.chat!));
      } else {
        debugPrint('❌ [AiChat] Chat history API returned success=false for chatId: ${event.chatId}');
        emit(AiChatError(message: 'Failed to load chat history'));
      }
    } catch (e, st) {
      debugPrint('❌ [AiChat] Exception loading chat history: $e');
      debugPrint('🔍 StackTrace: $st');
      emit(AiChatError(message: e.toString()));
    }
  }

  // ─── Load all chats for drawer ────────────────────────────────────────────────
  Future<void> _onLoadAllChats(LoadAllChatsEvent event, Emitter<AiChatState> emit) async {
    emit(ChatsLoading());
    try {
      final result = await _repository.getAllChats();
      emit(ChatsLoaded(result.chats));
    } catch (e) {
      emit(AiChatError(message: e.toString()));
    }
  }

  // ─── Reset chat (UI only) ─────────────────────────────────────────────────────
  Future<void> _onResetChat(ResetChatEvent event, Emitter<AiChatState> emit) async {
    emit(ChatReset());
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────
  List<MessageModel> _getMessagesFromState(AiChatState s) {
    if (s is MessageSending) return s.messages;
    if (s is MessageSent) return s.messages;
    if (s is AiChatError) return s.messages;
    if (s is ChatLoaded) return s.chat.messages;
    if (s is ChatHistoryLoaded) return s.chat.messages;
    return [];
  }

  String? _getChatIdFromState(AiChatState s) {
    if (s is MessageSending) return s.chatId;
    if (s is MessageSent) return s.chatId;
    if (s is AiChatError) return s.chatId;
    if (s is ChatLoaded) return s.chat.id;
    if (s is ChatHistoryLoaded) return s.chat.id;
    return null;
  }
}
