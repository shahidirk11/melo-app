import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import '../../logging/app_logger.dart';
import 'audio_service.dart';
import 'audio_types.dart';

class JustAudioService implements AudioService {
  JustAudioService({
    AudioPlayer? narrationPlayer,
    AudioPlayer? ambientPlayer,
  })  : _narrationPlayer = narrationPlayer ?? AudioPlayer(),
        _ambientPlayer = ambientPlayer ?? AudioPlayer() {
    _stateController = StreamController<AudioSessionSnapshot>.broadcast();
    _initAudioSession();
    _bindPlayerListeners();
  }

  final AudioPlayer _narrationPlayer;
  final AudioPlayer _ambientPlayer;
  late final StreamController<AudioSessionSnapshot> _stateController;

  AudioSessionSnapshot _snapshot = const AudioSessionSnapshot();
  bool _isDisposed = false;
  bool _wasPlayingBeforeInterruption = false;

  StreamSubscription<AudioInterruptionEvent>? _interruptionSub;
  StreamSubscription<void>? _noisySub;
  StreamSubscription<PlayerState>? _narrationStateSub;
  StreamSubscription<PlayerState>? _ambientStateSub;
  StreamSubscription<Duration>? _positionSub;

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

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      _interruptionSub = session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              handleInterruption(AudioInterruptionAction.duck);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              handleInterruption(AudioInterruptionAction.pause);
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              handleInterruption(AudioInterruptionAction.unduck);
              break;
            case AudioInterruptionType.pause:
              handleInterruption(AudioInterruptionAction.resume);
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });

      _noisySub = session.becomingNoisyEventStream.listen((_) {
        handleHeadphonesDisconnected();
      });
    } catch (e, stack) {
      AppLogger.w('Failed to initialize native AudioSession: $e', error: e, stackTrace: stack);
    }
  }

  void _bindPlayerListeners() {
    _narrationStateSub = _narrationPlayer.playerStateStream.listen((state) {
      final status = _mapProcessingState(state.processingState, state.playing);
      _emit(_snapshot.copyWith(narrationStatus: status));
    });

    _ambientStateSub = _ambientPlayer.playerStateStream.listen((state) {
      final status = _mapProcessingState(state.processingState, state.playing);
      _emit(_snapshot.copyWith(ambientStatus: status));
    });

    _positionSub = _narrationPlayer.positionStream.listen((pos) {
      _emit(_snapshot.copyWith(position: pos));
    });
  }

  AudioPlaybackStatus _mapProcessingState(ProcessingState state, bool isPlaying) {
    switch (state) {
      case ProcessingState.idle:
        return AudioPlaybackStatus.idle;
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return AudioPlaybackStatus.loading;
      case ProcessingState.ready:
        return isPlaying ? AudioPlaybackStatus.playing : AudioPlaybackStatus.paused;
      case ProcessingState.completed:
        return AudioPlaybackStatus.completed;
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

    bool hasNarration = false;
    bool hasAmbient = false;
    Duration? duration;

    // 1. Prepare Narration Voice Track
    if (narrationAsset != null && narrationAsset.isNotEmpty) {
      try {
        duration = await _narrationPlayer.setAsset(narrationAsset);
        hasNarration = true;
      } catch (e) {
        AppLogger.i('Narration audio asset unavailable: $narrationAsset. Gracefully continuing in text mode.');
        hasNarration = false;
      }
    }

    // 2. Prepare Ambient Sound Track
    if (ambientAsset != null && ambientAsset.isNotEmpty) {
      try {
        await _ambientPlayer.setAsset(ambientAsset);
        await _ambientPlayer.setLoopMode(LoopMode.one);
        hasAmbient = true;
      } catch (e) {
        AppLogger.i('Ambient audio asset unavailable: $ambientAsset.');
        hasAmbient = false;
      }
    }

    final isFallback = !hasNarration && !hasAmbient;

    await _applyVolumes();

    _emit(_snapshot.copyWith(
      narrationStatus: hasNarration ? AudioPlaybackStatus.idle : AudioPlaybackStatus.idle,
      ambientStatus: hasAmbient ? AudioPlaybackStatus.idle : AudioPlaybackStatus.idle,
      hasNarration: hasNarration,
      hasAmbient: hasAmbient,
      isFallbackMode: isFallback,
      duration: duration,
      position: Duration.zero,
    ));
  }

  Future<void> _applyVolumes() async {
    if (_isDisposed) return;

    final nVol = _snapshot.isMuted
        ? 0.0
        : (_snapshot.masterVolume * _snapshot.narrationVolume).clamp(0.0, 1.0);
    final aVol = _snapshot.isMuted
        ? 0.0
        : (_snapshot.masterVolume * _snapshot.ambientVolume).clamp(0.0, 1.0);

    try {
      await _narrationPlayer.setVolume(nVol);
      await _ambientPlayer.setVolume(aVol);
    } catch (_) {}
  }

  @override
  Future<void> play() async {
    if (_isDisposed) return;

    final futures = <Future<void>>[];
    if (_snapshot.hasNarration) {
      futures.add(_narrationPlayer.play());
    }
    if (_snapshot.hasAmbient) {
      futures.add(_ambientPlayer.play());
    }

    try {
      await Future.wait(futures);
    } catch (e) {
      AppLogger.w('Error starting audio playback: $e');
    }
  }

  @override
  Future<void> pause() async {
    if (_isDisposed) return;

    final futures = <Future<void>>[];
    if (_snapshot.hasNarration && _narrationPlayer.playing) {
      futures.add(_narrationPlayer.pause());
    }
    if (_snapshot.hasAmbient && _ambientPlayer.playing) {
      futures.add(_ambientPlayer.pause());
    }

    try {
      await Future.wait(futures);
    } catch (e) {
      AppLogger.w('Error pausing audio playback: $e');
    }
  }

  @override
  Future<void> resume() async {
    if (_isDisposed) return;
    await play();
  }

  @override
  Future<void> seek(Duration position) async {
    if (_isDisposed) return;

    try {
      if (_snapshot.hasNarration) {
        await _narrationPlayer.seek(position);
      }
      _emit(_snapshot.copyWith(position: position));
    } catch (e) {
      AppLogger.w('Error seeking audio track: $e');
    }
  }

  @override
  Future<void> stop() async {
    if (_isDisposed) return;

    try {
      await Future.wait([
        if (_snapshot.hasNarration) _narrationPlayer.stop(),
        if (_snapshot.hasAmbient) _ambientPlayer.stop(),
      ]);
      _emit(_snapshot.copyWith(
        narrationStatus: AudioPlaybackStatus.idle,
        ambientStatus: AudioPlaybackStatus.idle,
        position: Duration.zero,
      ));
    } catch (e) {
      AppLogger.w('Error stopping audio playback: $e');
    }
  }

  @override
  Future<void> setMasterVolume(double volume) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(masterVolume: volume.clamp(0.0, 1.0)));
    await _applyVolumes();
  }

  @override
  Future<void> setNarrationVolume(double volume) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(narrationVolume: volume.clamp(0.0, 1.0)));
    await _applyVolumes();
  }

  @override
  Future<void> setAmbientVolume(double volume) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(ambientVolume: volume.clamp(0.0, 1.0)));
    await _applyVolumes();
  }

  @override
  Future<void> setMuted(bool isMuted) async {
    if (_isDisposed) return;
    _emit(_snapshot.copyWith(isMuted: isMuted));
    await _applyVolumes();
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
        await _applyVolumes();
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
        await _applyVolumes();
        break;
    }
  }

  @override
  Future<void> handleHeadphonesDisconnected() async {
    if (_isDisposed) return;
    if (_snapshot.isPlaying) {
      await pause();
    }
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;

    await _interruptionSub?.cancel();
    await _noisySub?.cancel();
    await _narrationStateSub?.cancel();
    await _ambientStateSub?.cancel();
    await _positionSub?.cancel();

    try {
      await _narrationPlayer.dispose();
      await _ambientPlayer.dispose();
    } catch (_) {}

    await _stateController.close();
  }
}
