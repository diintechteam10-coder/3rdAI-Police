import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/response/voice_response_models.dart';

class AiVoiceRepository {
  final Dio _dio = ApiService.dio;
  Future<bool> checkHealth() async {
    try {
      print("🚀 REQUEST → GET ${ApiConstants.healthCheck}");
      final response = await _dio.get(ApiConstants.healthCheck,options: Options(extra: {'skipClientId': true}));
      print("✅ RESPONSE ← ${response.statusCode} - ${response.data}");
      return response.data['status'] == 'OK';
    } catch (e) {
      print("❌ HEALTH CHECK ERROR: $e");
      return false;
    }
  }
  Future<VoiceSessionResponse> startVoiceSession({String chatId = 'new'}) async {
    try {
      final data = {'chatId': chatId};
      print("🚀 REQUEST → POST ${ApiConstants.voiceStart}");
      print("📤 BODY → $data");

      final response = await _dio.post(
        ApiConstants.voiceStart,
        data: data,
        options: Options(extra: {'skipClientId': true}),
      );

      print("✅ RESPONSE ← ${response.statusCode}");
      print("📦 DATA → ${response.data}");
      
      return VoiceSessionResponse.fromJson(response.data);
    } catch (e) {
      print("❌ VOICE START ERROR: $e");
      return VoiceSessionResponse(success: false, message: e.toString());
    }
  }
 Future<VoiceProcessResponse> processVoice({
    required String chatId,
    required String base64Audio,
    String format = 'webm',
  }) async {
    try {
      final data = {
        'chatId': chatId,
        'audioData': base64Audio,
        'audioFormat': format,
      };
      print("🚀 REQUEST → POST ${ApiConstants.voiceProcess}");
      // Don't log full base64 to avoid terminal spam, just length
      print("📤 BODY → {chatId: $chatId, audioData: [base64_len=${base64Audio.length}], audioFormat: $format}");

      final response = await _dio.post(
        ApiConstants.voiceProcess,
        data: data,
        options: Options(extra: {'skipClientId': true}),
      );

      print("✅ RESPONSE ← ${response.statusCode}");
      final result = VoiceProcessResponse.fromJson(response.data);
      
      if (result.success && result.data != null) {
        print("🎤 USER: ${result.data!.transcribedText}");
        print("🤖 AI: ${result.data!.aiResponse}");
      }
      
      return result;
    } catch (e) {
      print("❌ VOICE PROCESS ERROR: $e");
      return VoiceProcessResponse(success: false);
    }
  }
}
