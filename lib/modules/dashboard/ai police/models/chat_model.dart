class ChatModel {
  final String id;
  final String title;
  final String agentId;
  final String status;
  final List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.agentId,
    required this.status,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['chatId'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      agentId: json['agentId'] ?? '',
      status: json['status'] ?? '',
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class MessageModel {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime? createdAt;

  MessageModel({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['chatId'] ?? json['_id'] ?? '',
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class CreateChatResponseModel {
  final bool success;
  final String? chatId;
  final String? title;

  CreateChatResponseModel({required this.success, this.chatId, this.title});

  factory CreateChatResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return CreateChatResponseModel(
      success: json['success'] ?? false,
      // Server returns { chatId: "...", title: "...", createdAt: "..." }
      chatId: data?['chatId'] ?? data?['_id'],
      title: data?['title'],
    );
  }
}

class SendMessageResponseModel {
  final bool success;
  final MessageModel? userMessage;
  final MessageModel? assistantMessage;

  SendMessageResponseModel({
    required this.success,
    this.userMessage,
    this.assistantMessage,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SendMessageResponseModel(
      success: json['success'] ?? false,
      userMessage: data?['userMessage'] != null
          ? MessageModel.fromJson(data['userMessage'])
          : null,
      assistantMessage: data?['assistantMessage'] != null
          ? MessageModel.fromJson(data['assistantMessage'])
          : null,
    );
  }
}

class ChatHistoryResponseModel {
  final bool success;
  final ChatModel? chat;

  ChatHistoryResponseModel({required this.success, this.chat});

  factory ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponseModel(
      success: json['success'] ?? false,
      chat: json['data'] != null ? ChatModel.fromJson(json['data']) : null,
    );
  }
}

/// Lightweight model for the all-chats list (drawer)
class ChatSummaryModel {
  final String id;
  final String title;
  final String agentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatSummaryModel({
    required this.id,
    required this.title,
    required this.agentId,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChatSummaryModel(
      id: json['chatId'] ?? json['_id'] ?? '',
      title: json['title'] ?? 'Untitled Chat',
      agentId: json['agentId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class AllChatsResponseModel {
  final bool success;
  final List<ChatSummaryModel> chats;

  AllChatsResponseModel({required this.success, required this.chats});

  factory AllChatsResponseModel.fromJson(Map<String, dynamic> json) {
    return AllChatsResponseModel(
      success: json['success'] ?? false,
      chats: (json['data'] as List<dynamic>?)
              ?.map((e) => ChatSummaryModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
