import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum VoiceAgentState {
  IDLE,
  CONNECTING,
  LISTENING,
  PROCESSING,
  SPEAKING,
  ERROR,
}

class VoiceAudioService extends ChangeNotifier {
  AudioRecorder? _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  VoiceAgentState _state = VoiceAgentState.IDLE;
  VoiceAgentState get state => _state;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String _interimText = "";
  String get interimText => _interimText;

  String _aiText = "";
  String get aiText => _aiText;

  final List<int> _audioBytesAccumulator = [];
  final List<File> _tempAudioFiles = [];
  StreamSubscription? _audioCompletionSubscription;
  StreamSubscription? _recordSub;

  // Callbacks
  Function()? onSilenceDetected;

  // Tuning silence threshold and timeout
  final double silenceThreshold = 0.02;
  final Duration silenceTimeout = const Duration(milliseconds: 2000);

  // VAD flags
  bool _hasVoiceActivity = false;
  DateTime? _lastVoiceActivity;

  void _setState(VoiceAgentState newState) {
    if (_state != newState) {
      _state = newState;
      debugPrint('[VoiceAgent] State changed: ${newState.name}');
      notifyListeners();
    }
  }

  Future<void> _startMicrophone(Function(String chunk)? onData) async {
    try {
      if (_recorder == null) {
        _recorder = AudioRecorder();
      }

      if (await _recorder!.isRecording() || _player.playing) {
        debugPrint('[VoiceAgent] Recording or playing already active.');
        return;
      }

      if (await _recorder!.hasPermission()) {
        debugPrint('[VoiceAgent] Starting microphone recording...');

        _hasVoiceActivity = false;
        _lastVoiceActivity = DateTime.now();

        // Configure AudioSession for output
        try {
          final session = await AudioSession.instance;
          await session.configure(AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
            avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.defaultToSpeaker,
            avAudioSessionMode: AVAudioSessionMode.videoChat,
            androidAudioAttributes: const AndroidAudioAttributes(
              contentType: AndroidAudioContentType.speech,
              flags: AndroidAudioFlags.none,
              usage: AndroidAudioUsage.voiceCommunication,
            ),
            androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          ));
          await session.setActive(true);
          await Helper.setSpeakerphoneOn(true);
        } catch (e) {
          debugPrint('[VoiceAgent] AudioSession Error: $e');
        }

        final stream = await _recorder!.startStream(
          const RecordConfig(
            encoder: AudioEncoder.pcm16bits,
            sampleRate: 16000,
            numChannels: 1,
          ),
        );

        _setState(VoiceAgentState.LISTENING);
        _recordSub = stream.listen((data) {
          _processAudioData(data, onData);
        });
      }
    } catch (e) {
      debugPrint('[VoiceAgent] Mic Error: $e');
      _errorMessage = 'Mic Error: $e';
      _setState(VoiceAgentState.ERROR);
    }
  }

  double _calculateRMS(Uint8List bytes) {
    if (bytes.isEmpty) return 0.0;
    double sumOfSquares = 0.0;
    final int samples = bytes.length ~/ 2;
    for (int i = 0; i < bytes.length - 1; i += 2) {
      int sample = bytes[i] | (bytes[i + 1] << 8);
      if (sample >= 32768) {
        sample -= 65536;
      }
      double normalized = sample / 32768.0;
      sumOfSquares += normalized * normalized;
    }
    return sqrt(sumOfSquares / samples);
  }

  Future<void> _stopMicrophone() async {
    debugPrint('[VoiceAgent] Pausing Microphone...');
    await _recordSub?.cancel();
    _recordSub = null;
    
    try {
      if (_recorder != null && await _recorder!.isRecording()) {
        await _recorder!.stop();
      }
    } catch (e) {
      debugPrint('[VoiceAgent] Error stopping recorder: $e');
    }
  }

  void _processAudioData(Uint8List bytes, Function(String chunk)? onData) {
    if (_state != VoiceAgentState.LISTENING) return;

    double rms = _calculateRMS(bytes);
    if (rms > silenceThreshold) {
      if (!_hasVoiceActivity) {
        debugPrint('[VoiceAgent] Voice activity started.');
      }
      _hasVoiceActivity = true;
      _lastVoiceActivity = DateTime.now();
    } else if (_hasVoiceActivity && _lastVoiceActivity != null) {
      final silenceDuration = DateTime.now().difference(_lastVoiceActivity!);
      if (silenceDuration > silenceTimeout) {
        debugPrint('[VoiceAgent] Local silence detected.');
        _stopMicrophone();
        onSilenceDetected?.call();
        return;
      }
    }
    
    if (onData != null) {
      final base64Audio = base64Encode(bytes);
      onData(base64Audio);
    }
  }

  // AI Response triggers
  void updateInterimText(String text) {
    _interimText = text;
    notifyListeners();
  }

  void updateAiText(String text) {
    _aiText = text;
    _setState(VoiceAgentState.SPEAKING);
    notifyListeners();
  }

  void addAudioChunk(String base64Chunk) {
    if (_state != VoiceAgentState.SPEAKING) {
      _setState(VoiceAgentState.SPEAKING);
      _stopMicrophone(); // ensure mic is off while AI speaks
    }
    final bytes = base64Decode(base64Chunk);
    _audioBytesAccumulator.addAll(bytes);
  }

  Future<void> playBufferedAudio() async {
    debugPrint('[VoiceAgent] Audio complete. Playing accumulated response.');
    if (_audioBytesAccumulator.isEmpty) return;

    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/agent_full_audio_$timestamp.mp3';
      final file = File(path);

      await file.writeAsBytes(_audioBytesAccumulator);
      _tempAudioFiles.add(file);
      _audioBytesAccumulator.clear();

      await _audioCompletionSubscription?.cancel();
      final completer = Completer<void>();
      
      _audioCompletionSubscription = _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (!completer.isCompleted) completer.complete();
        }
      });

      await _player.setAudioSource(AudioSource.uri(Uri.file(path)));
      await _player.play();
      await completer.future;
      await _player.stop();

      try {
        if (file.existsSync()) {
          file.delete();
          _tempAudioFiles.remove(file);
        }
      } catch (_) {}
    } catch (e) {
      debugPrint('[VoiceAgent] Audio playback error: $e');
    }

    debugPrint('[VoiceAgent] Agent finished speaking.');
    _interimText = "";
    _setState(VoiceAgentState.LISTENING);
  }

  Future<void> _cleanup() async {
    debugPrint('[VoiceAgent] Cleanup resources.');
    try {
      await _audioCompletionSubscription?.cancel();
      await _recordSub?.cancel();
      _recordSub = null;

      if (_recorder != null) {
        if (await _recorder!.isRecording()) {
          await _recorder!.stop();
        }
      }

      _audioBytesAccumulator.clear();
      await _player.stop();

      for (var file in _tempAudioFiles) {
        try {
          if (file.existsSync()) file.delete();
        } catch (_) {}
      }
      _tempAudioFiles.clear();
    } catch (e) {
      debugPrint('[VoiceAgent] Cleanup error: $e');
    }
  }

  @override
  void dispose() {
    _cleanup();
    _player.dispose();
    _recorder?.dispose();
    _recorder = null;
    super.dispose();
  }

  // --- External API for Bloc ---
  void clearAudioBuffer() {
    _audioBytesAccumulator.clear();
  }

  Future<void> stopRecording() async {
    await _stopMicrophone();
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  Future<void> startRecording(Function(String chunk) onData) async {
    await _startMicrophone(onData);
  }
}
