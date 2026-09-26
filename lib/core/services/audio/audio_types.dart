import 'package:equatable/equatable.dart';

enum AudioPlaybackStatus {
  idle,
  loading,
  playing,
  paused,
  completed,
  error,
}

enum AudioTrackType {
  narration,
  ambient,
}

enum AudioInterruptionAction {
  pause,
  duck,
  resume,
  unduck,
}

class AudioSessionSnapshot extends Equatable {
  const AudioSessionSnapshot({
    this.narrationStatus = AudioPlaybackStatus.idle,
    this.ambientStatus = AudioPlaybackStatus.idle,
    this.position = Duration.zero,
    this.duration,
    this.hasNarration = false,
    this.hasAmbient = false,
    this.isMuted = false,
    this.masterVolume = 1.0,
    this.narrationVolume = 1.0,
    this.ambientVolume = 0.5,
    this.isFallbackMode = false,
    this.errorMessage,
  });

  final AudioPlaybackStatus narrationStatus;
  final AudioPlaybackStatus ambientStatus;
  final Duration position;
  final Duration? duration;
  final bool hasNarration;
  final bool hasAmbient;
  final bool isMuted;
  final double masterVolume;
  final double narrationVolume;
  final double ambientVolume;
  final bool isFallbackMode;
  final String? errorMessage;

  bool get isPlaying =>
      narrationStatus == AudioPlaybackStatus.playing ||
      ambientStatus == AudioPlaybackStatus.playing;

  bool get isPaused =>
      narrationStatus == AudioPlaybackStatus.paused ||
      ambientStatus == AudioPlaybackStatus.paused;

  bool get hasActiveAudio => hasNarration || hasAmbient;

  AudioSessionSnapshot copyWith({
    AudioPlaybackStatus? narrationStatus,
    AudioPlaybackStatus? ambientStatus,
    Duration? position,
    Duration? duration,
    bool? hasNarration,
    bool? hasAmbient,
    bool? isMuted,
    double? masterVolume,
    double? narrationVolume,
    double? ambientVolume,
    bool? isFallbackMode,
    String? errorMessage,
  }) {
    return AudioSessionSnapshot(
      narrationStatus: narrationStatus ?? this.narrationStatus,
      ambientStatus: ambientStatus ?? this.ambientStatus,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      hasNarration: hasNarration ?? this.hasNarration,
      hasAmbient: hasAmbient ?? this.hasAmbient,
      isMuted: isMuted ?? this.isMuted,
      masterVolume: masterVolume ?? this.masterVolume,
      narrationVolume: narrationVolume ?? this.narrationVolume,
      ambientVolume: ambientVolume ?? this.ambientVolume,
      isFallbackMode: isFallbackMode ?? this.isFallbackMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        narrationStatus,
        ambientStatus,
        position,
        duration,
        hasNarration,
        hasAmbient,
        isMuted,
        masterVolume,
        narrationVolume,
        ambientVolume,
        isFallbackMode,
        errorMessage,
      ];
}
