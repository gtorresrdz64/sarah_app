import 'package:audioplayers/audioplayers.dart';

class AudioPlaybackService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentAsset;

  String? get currentAsset => _currentAsset;

  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  Future<void> play(String assetPath) async {
    try {
      await _player.stop();
      _currentAsset = assetPath;
      final sourcePath = assetPath.replaceFirst('assets/', '');
      await _player.play(AssetSource(sourcePath));
    } catch (_) {
      _currentAsset = null;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentAsset = null;
  }

  void dispose() {
    _player.dispose();
  }
}
