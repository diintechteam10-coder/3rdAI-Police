import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceAudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Uint8List>? _recordSub;

  final List<String> _audioChunks = [];

  bool _isPlaying = false;
  bool _isRecording = false;

  Function()? onSilenceDetected;
  Function(String)? _onDataCallback;

  Timer? _silenceTimer;

  bool get isPlaying => _isPlaying;
  bool get isRecording => _isRecording;

  /// 🎤 START RECORDING
  Future<void> startRecording(Function(String base64Chunk) onData) async {
    try {
      if (_isRecording) return;

      if (await _recorder.hasPermission()) {
        _onDataCallback = onData;

        const config = RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        );

        final stream = await _recorder.startStream(config);

        _isRecording = true;

        _recordSub = stream.listen((data) {
          final base64Chunk = base64Encode(data);
          _onDataCallback?.call(base64Chunk);

          // 🔥 Reset silence timer
          _silenceTimer?.cancel();
          _silenceTimer = Timer(const Duration(seconds: 2), () async {
            print("🤫 Silence detected → stopping mic");
            await stopRecording();
            onSilenceDetected?.call();
          });
        });

        print("🎤 Recording STARTED");
      }
    } catch (e) {
      print("❌ Recording error: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;

    await _recordSub?.cancel();
    await _recorder.stop();
    _silenceTimer?.cancel();

    _isRecording = false;

    print("🎤 Recording STOPPED");
  }

  /// 🔊 CLEAR BUFFER
  void clearAudioBuffer() {
    _audioChunks.clear();
  }

  /// ➕ ADD AI AUDIO
  void addAudioChunk(String base64Chunk) {
    _audioChunks.add(base64Chunk);
  }

  /// 🔊 PLAY AI AUDIO
  Future<void> playBufferedAudio() async {
    if (_audioChunks.isEmpty) return;

    final completer = Completer<void>();
    StreamSubscription? completeSub;

    try {
      _isPlaying = true;
      print("🔊 Playing AI audio...");

      final List<int> fullAudio = [];
      for (final chunk in _audioChunks) {
        fullAudio.addAll(base64Decode(chunk));
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/ai.wav');

      await file.writeAsBytes(fullAudio);

      completeSub = _player.onPlayerComplete.listen((event) {
        print("✅ AI SPEAKING DONE");
        _isPlaying = false;
        completeSub?.cancel();
        if (!completer.isCompleted) completer.complete();
      });

      await _player.play(DeviceFileSource(file.path));
      
      // Wait for audio to actually finish
      await completer.future;

    } catch (e) {
      _isPlaying = false;
      print("❌ Playback error: $e");
      completeSub?.cancel();
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    _isPlaying = false;
  }

  void dispose() {
    _recorder.dispose();
    _player.dispose();
    _recordSub?.cancel();
    _silenceTimer?.cancel();
  }
}
