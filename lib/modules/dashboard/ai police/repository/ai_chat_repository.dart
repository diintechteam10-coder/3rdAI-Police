import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/chat_model.dart';
import '../models/response/get_agents_response_model.dart';

class AiChatRepository {
  final Dio _dio = ApiService.dio;

  /// GET /api/mobile/agents
  Future<AgentResponseModel> getAgents() async {
    final response = await _dio.get(
      ApiConstants.getAgents,
      options: Options(extra: {'skipClientId': true}),
    );
    return AgentResponseModel.fromJson(response.data);
  }

  Future<CreateChatResponseModel> createChat(String agentId) async {
    final response = await _dio.post(
      ApiConstants.createChat,
      options: Options(extra: {'skipClientId': true}),
      data: {'title': 'Chat with AI', 'agentId': agentId},
    );
    return CreateChatResponseModel.fromJson(response.data);
  }

  /// POST /api/mobile/chat/{chatId}/message
  /// Body: { "message": "" }
  Future<SendMessageResponseModel> sendMessage(
    String chatId,
    String message,
  ) async {
    final response = await _dio.post(
      '${ApiConstants.sendMessage}/$chatId/message',
      options: Options(extra: {'skipClientId': true}),
      data: {'message': message},
    );
    return SendMessageResponseModel.fromJson(response.data);
  }

  /// GET /api/mobile/chat/{chatId}
  Future<ChatHistoryResponseModel> getChatHistory(String chatId) async {
    final response = await _dio.get(
      '${ApiConstants.getChatHistory}/$chatId',
      options: Options(extra: {'skipClientId': true}),
    );
    return ChatHistoryResponseModel.fromJson(response.data);
  }

  /// GET /api/mobile/chat  — all chats list for drawer
  Future<AllChatsResponseModel> getAllChats() async {
    final response = await _dio.get(
      ApiConstants.getAllChats,
      options: Options(extra: {'skipClientId': true}),
    );
    return AllChatsResponseModel.fromJson(response.data);
  }
}
