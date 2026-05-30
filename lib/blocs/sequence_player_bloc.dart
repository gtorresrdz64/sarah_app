import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../services/audio_playback_service.dart';

class SequencePlayerBloc extends ChangeNotifier {
  final AudioPlaybackService _audioPlaybackService;
  final List<String> _sequence;
  int _currentIndex = 0;
  bool _isPlaying = false;
  Timer? _playbackTimer;

  // Status variables
  String _currentAssetName = '';
  String _currentStatusMessage = '';
  double _overallProgress = 0.0;
  bool _isSequenceFinished = false;

  SequencePlayerBloc({
    required this._audioPlaybackService,
    required this._sequence,
  }) {
    _init();
  }

  void _init() {
    _currentStatusMessage = 'Ready to start sequence.';
    notifyListeners();
  }

  // Set up audio player service listeners
  void _setupPlayerListeners() {
    _audioPlaybackService.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        // Current audio finished, proceed to next or wait
        _onAudioCompleted();
      }
    });

    _audioPlaybackService.onPositionChanged.listen((position) {
      if (_sequence.isNotEmpty && _currentIndex < _sequence.length) {
        final totalDuration = const Duration(seconds: 1); // Mock duration
        final currentPosition = position;
        // _overallProgress = (_currentIndex / _sequence.length) + (currentPosition.inSeconds / totalDuration.inSeconds / _sequence.length);
        // notifyListeners();
      }
    });
  }

  void startSequence() async {
    if (_isPlaying || _sequence.isEmpty) return;

    _isPlaying = true;
    _currentIndex = 0;
    _isSequenceFinished = false;
    _currentStatusMessage = 'Sequence started.';
    notifyListeners();

    _setupPlayerListeners(); // Ensure listeners are attached before playing

    await _playCurrentAsset();
  }

  Future<void> _playCurrentAsset() async {
    if (_currentIndex >= _sequence.length) {
      _finishSequence();
      return;
    }

    _currentAssetName = _sequence[_currentIndex];
    _currentStatusMessage = 'Playing step ${_currentIndex + 1}/${_sequence.length}: ${_currentAssetName.split('/').last}';
    // _overallProgress = _currentIndex / _sequence.length;
    notifyListeners();

    try {
      await _audioPlaybackService.play(_currentAssetName);
    } catch (e) {
      _currentStatusMessage = 'Error playing asset: $e';
      _finishSequence();
    }
  }

  void _onAudioCompleted() {
    if (!_isPlaying) return;

    _currentIndex++;

    if (_currentIndex < _sequence.length) {
      // Not finished yet, wait and play next
      _currentStatusMessage = 'Step $_currentIndex completed. Waiting 10 seconds before next step...';
      _overallProgress = _currentIndex / _sequence.length;
      notifyListeners();

      _playbackTimer = Timer(const Duration(seconds: 10), () {
        _playCurrentAsset();
      });
    } else {
      // Last asset finished
      _finishSequence();
    }
  }

  void _finishSequence() {
    _isPlaying = false;
    _playbackTimer?.cancel();
    _currentStatusMessage = 'Sequence completed successfully.';
    _currentIndex = _sequence.length;
    _overallProgress = 1.0;
    _isSequenceFinished = true;
    notifyListeners();
  }

  void stopSequence() {
    if (!_isPlaying) return;

    _isPlaying = false;
    _playbackTimer?.cancel();
    _audioPlaybackService.stop();
    _currentStatusMessage = 'Sequence stopped by user.';
    _currentIndex = 0;
    _overallProgress = 0.0;
    notifyListeners();
  }

  // Getters for UI
  String get currentAssetName => _currentAssetName;
  String get currentStatusMessage => _currentStatusMessage;
  double get overallProgress => _overallProgress;
  int get currentIndex => _currentIndex;
  int get totalSteps => _sequence.length;
  bool get isPlaying => _isPlaying;
  bool get isSequenceFinished => _isSequenceFinished;
  String? get currentPlayingAsset => _audioPlaybackService.currentAsset;

  @override
  void dispose() {
    _playbackTimer?.cancel();
    // We don't dispose the service here as it might be shared.
    // Assuming the service will handle its own disposal if needed.
    // _audioPlaybackService.dispose();
    super.dispose();
  }
}
