import 'package:speech_to_text/speech_to_text.dart';

class VoiceRecognitionService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;

  Future<bool> initialize() async {
    _isAvailable = await _speech.initialize();
    return _isAvailable;
  }

  bool get isListening => _speech.isListening;

  Future<void> startListening(Function(String text) onResult) async {
    if (!_isAvailable) return;
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 10),
      ),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  void dispose() {
    _speech.stop();
  }
}
