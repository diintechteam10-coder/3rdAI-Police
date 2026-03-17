import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Events emitted by the WebSocket server
enum WsEventType {
  transcript,
  userMessage,
  aiResponse,
  audioChunk,
  audioComplete,
  error,
  unknown,
}

class WsEvent {
  final WsEventType type;
  final Map<String, dynamic> data;

  WsEvent({required this.type, required this.data});
}

/// Reusable WebSocket service for AI voice & real-time messaging
class WebSocketService {
  WebSocketChannel? _channel;
  final _controller = StreamController<WsEvent>.broadcast();

  /// Broadcast stream – multiple listeners supported
  Stream<WsEvent> get stream => _controller.stream;

  bool get isConnected => _channel != null;

  /// Connect to the WebSocket with a bearer token
  void connect(String token) {
    disconnect(); // ensure clean state

    final uri = Uri.parse(
      'wss://threerdai-backend-5nvu.onrender.com/api/voice/agent?token=$token',
    );

    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (raw) {
        try {
          final json = jsonDecode(raw as String) as Map<String, dynamic>;
          final eventType = _parseEventType(json['event'] as String? ?? '');
          _controller.add(WsEvent(type: eventType, data: json));
        } catch (e) {
          _controller.add(WsEvent(
            type: WsEventType.error,
            data: {'message': 'Parse error: $e'},
          ));
        }
      },
      onError: (error) {
        _controller.add(WsEvent(
          type: WsEventType.error,
          data: {'message': error.toString()},
        ));
      },
      onDone: () {
        _controller.add(WsEvent(
          type: WsEventType.unknown,
          data: {'message': 'Connection closed'},
        ));
      },
    );
  }

  /// Send a JSON payload through the socket
  void send(Map<String, dynamic> data) {
    if (_channel == null) return;
    _channel!.sink.add(jsonEncode(data));
  }

  /// Listen to a specific event type
  Stream<WsEvent> listen(WsEventType type) {
    return _controller.stream.where((e) => e.type == type);
  }

  /// Close the connection cleanly
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  WsEventType _parseEventType(String event) {
    switch (event) {
      case 'transcript':
        return WsEventType.transcript;
      case 'user_message':
        return WsEventType.userMessage;
      case 'ai_response':
        return WsEventType.aiResponse;
      case 'audio_chunk':
        return WsEventType.audioChunk;
      case 'audio_complete':
        return WsEventType.audioComplete;
      case 'error':
        return WsEventType.error;
      default:
        return WsEventType.unknown;
    }
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
