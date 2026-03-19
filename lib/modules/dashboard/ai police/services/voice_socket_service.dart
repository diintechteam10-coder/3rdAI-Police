import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/response/voice_response_models.dart';

class VoiceSocketService {
  WebSocketChannel? _channel;
  final StreamController<VoiceEvent> _eventController =
      StreamController<VoiceEvent>.broadcast();

  Stream<VoiceEvent> get events => _eventController.stream;

  bool get isConnected => _channel != null;

  /// Connect to WebSocket
  Future<void> connect(String token) async {
    try {
      final uri = Uri.parse(ApiConstants.wsBaseUrl);
      print("🔌 Connecting to WebSocket: $uri");

      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onDone: () {
          print("🔌 WebSocket connection closed");
          _channel = null;
        },
        onError: (error) {
          print("❌ WebSocket Error: $error");
          _eventController.add(VoiceErrorEvent(message: error.toString()));
          _channel = null;
        },
      );

      // Send Auth Message immediately
      sendAuth(token);
    } catch (e) {
      print("❌ WebSocket Connection Failed: $e");
      _eventController.add(VoiceErrorEvent(message: e.toString()));
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final type = data['type'];

      print("📥 RECEIVED EVENT: $type");
      if (type != 'audio_chunk') {
        print("📦 DATA: $data");
      }

      switch (type) {
        case 'transcript':
          final event = TranscriptEvent.fromJson(data);
          if (event.isFinal) {
            print("🎤 USER: ${event.text}");
          }
          _eventController.add(event);
          break;
        case 'ai_response':
          final event = AiResponseEvent.fromJson(data);
          print("🤖 AI: ${event.text}");
          _eventController.add(event);
          break;
        case 'audio_chunk':
          final event = AudioChunkEvent.fromJson(data);
          _eventController.add(event);
          break;
        case 'audio_complete':
          final event = AudioCompleteEvent.fromJson(data);
          print("✅ AI Audio Complete (Chunks: ${event.totalChunks})");
          _eventController.add(event);
          break;
        case 'auth_ok':
          print("✅ WebSocket Authenticated");
          _eventController.add(AuthOkEvent());
          break;
        case 'error':
          final event = VoiceErrorEvent.fromJson(data);
          print("❌ [WS ERROR]: ${event.message}");
          _eventController.add(event);
          break;
        default:
          print("⚠️ Unhandled event type: $type");
      }
    } catch (e) {
      print("❌ Error Parsing WS Message: $e");
    }
  }

  void sendAuth(String token) {
    _send({'type': 'auth', 'token': token});
  }

  void startSession(
    String chatId, {
    String voiceName = 'krishna1',
    String? agentId,
    String? firstMessage,
  }) {
    _send({
      'type': 'start',
      'chatId': chatId,
      'voiceName': voiceName,
      'agentId': agentId,
      'firstMessage': firstMessage,
    });
  }

  void sendAudio(String base64Audio) {
    _send({'type': 'audio', 'audio': base64Audio});
  }

  void sendAudioEnd() {
    print("📤 Sending: input_audio_end");
    _send({'type': 'input_audio_end'});
  }

  void stopSession() {
    _send({'type': 'stop'});
  }

  void _send(Map<String, dynamic> data) {
    if (_channel == null) {
      print("⚠️ Cannot send message: WebSocket not connected");
      return;
    }
    final msg = jsonEncode(data);
    print("📤 SENDING EVENT: ${data['type']}");
    if (data['type'] != 'audio') {
      print("📦 DATA: $msg");
    }
    _channel!.sink.add(msg);
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
