import 'dart:async';
import 'audio_service.dart';
import 'audio_types.dart';

class InMemoryAudioService implements AudioService {
  InMemoryAudioService({
    AudioSessionSnapshot initialSnapshot = const AudioSessionSnapshot(),
    this.simulateMissingAsset = false,
  }) : _snapshot = initialSnapshot {
    _stateController = StreamController<AudioSessionSnapshot>.broadcast();
  }

  AudioSessionSnapshot _snapshot;
  final bool simulateMissingAsset;
  late final StreamController<AudioSessionSnapshot> _stateController;

  bool _isDisposed = false;
  bool _wasPlayingBeforeInterruption = false;

  @override
  Stream<AudioSessionSnapshot> get stateStream => _stateController.stream;

  @override
  AudioSessionSnapshot get currentSnapshot => _snapshot;

  void _emit(AudioSessionSnapshot updated) {
    if (_isDisposed) return;
    _snapshot = updated;
    if (!_stateController.isClosed) {
      _stateController.add(_snapshot);
    }
  }

  @override
  Future<void> prepareSessionAudio({
    String? narrationAsset,
    String? ambientAsset,
    bool allowBackground = true,
  }) async {
    if (_isDisposed) return;

    _emit(_snapshot.copyWith(
      narrationStatus: AudioPlaybackStatus.loading,
      ambientStatus: AudioPlaybackStatus.loading,
    ));

    // Handle missing asset simulation or empty assets
    final hasNarration = narrationAsset != null &&
        narrationAsset.isNotEmpty &&
        !simulateMissingAsset &&
        !narrationAsset.contains('missing');

    final hasAmbient = ambientAsset != null &&
        ambientAsset.isNotEmpty &&
        !simulateMissingAsset &&
        !ambientAsset.contains('missing');

    final isFallback = !hasNarration && !hasAmbient;

    _emit(_snapshot.copyWith(
      narrationStatus: hasNarration
          ? AudioPlaybackStatus.idle
          : (isFallback ? AudioPlaybackStatus.idle : AudioPlaybackStatus.idle),
      ambientStatus: hasAmbient ? AudioPlaybackStatus.idle : AudioPlaybackStatus.idle,
      hasNarration: hasNarration,
      hasAmbient: hasAmbient,
      isFallbackMode: isFallback,
      position: Duration.zero,
      errorMessage: null,
    ));
  }

  @override
  Future<void> play() async {
    if (_isDisposed) return;

    final nStatus = (_snapshot.hasNarration || _snapshot.isFallbackMode)
        ? AudioPlaybackStatus.playing
        : _snapshot.narrationStatus;
    final aStatus = _snapshot.hasAmbient
        ? AudioPlaybackStatus.playing
        : _snapshot.ambientStatus;

    _emit(_snapshot.copyWith(
      narrationStatus: nStatus,
      ambientStatus: aStatus,
    ));
  }

  @override
  Future<void> pause() async {
    if (_isDisposed) return;

    final nStatus = _snapshot.narrationStatus == AudioPlaybackStatus.playing
        ? AudioPlaybackStatus.paused
        : _snapshot.narrationStatus;
    final aStatus = _snapshot.ambientStatus == AudioPlaybackStatus.playing
        ? AudioPlaybackStatus.paused
        : _snapshot.ambientStatus;

    _emit(_snapshot.copyWith(
      narrationStatus: nStatus,
      ambientStatus: aStatus,
    ));
  }

  @override
  Future<void> resume() async {
    if (_isDisposed) return;
    await play();
  }

  @override
  Future<void> seek(Duration position) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(position: position));
  }

  @override
  Future<void> stop() async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(
      narrationStatus: AudioPlaybackStatus.idle,
      ambientStatus: AudioPlaybackStatus.idle,
      position: Duration.zero,
    ));
  }

  @override
  Future<void> setMasterVolume(double volume) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(masterVolume: volume.clamp(0.0, 1.0)));
  }

  @override
  Future<void> setNarrationVolume(double volume) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(narrationVolume: volume.clamp(0.0, 1.0)));
  }

  @override
  Future<void> setAmbientVolume(double volume) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(ambientVolume: volume.clamp(0.0, 1.0)));
  }

  @override
  Future<void> setMuted(bool isMuted) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(isMuted: isMuted));
  }

  @override
  Future<void> handleInterruption(AudioInterruptionAction action) async {
    if (_isDisposed) return;

    switch (action) {
      case AudioInterruptionAction.pause:
        _wasPlayingBeforeInterruption = _snapshot.isPlaying;
        if (_snapshot.isPlaying) {
          await pause();
        }
        break;
      case AudioInterruptionAction.duck:
        _emit(_snapshot.copyWith(
          narrationVolume: _snapshot.narrationVolume * 0.3,
          ambientVolume: _snapshot.ambientVolume * 0.3,
        ));
        break;
      case AudioInterruptionAction.resume:
        if (_wasPlayingBeforeInterruption) {
          _wasPlayingBeforeInterruption = false;
          await resume();
        }
        break;
      case AudioInterruptionAction.unduck:
        _emit(_snapshot.copyWith(
          narrationVolume: 1.0,
          ambientVolume: 0.5,
        ));
        break;
    }
  }

  @override
  Future<void> handleHeadphonesDisconnected() async {
    if (_isDisposed) return;
    // When headphones are unplugged, immediately pause to avoid loud speaker output
    if (_snapshot.isPlaying) {
      await pause();
    }
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _emit(_snapshot.copyWith(
      narrationStatus: AudioPlaybackStatus.idle,
      ambientStatus: AudioPlaybackStatus.idle,
    ));
    await _stateController.close();
  }
}
