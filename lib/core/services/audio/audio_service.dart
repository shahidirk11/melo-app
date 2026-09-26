import 'dart:async';
import 'audio_types.dart';

/// Clean abstraction for production meditation audio.
/// Decouples UI and SessionEngine from the underlying audio player implementation.
abstract class AudioService {
  /// Stream emitting real-time audio session state changes.
  Stream<AudioSessionSnapshot> get stateStream;

  /// Current snapshot of audio playback state.
  AudioSessionSnapshot get currentSnapshot;

  /// Prepares audio sources for the upcoming session.
  /// If an asset is missing or unavailable, activates graceful fallback without throwing.
  Future<void> prepareSessionAudio({
    String? narrationAsset,
    String? ambientAsset,
    bool allowBackground = true,
  });

  /// Starts or resumes playback for all active tracks.
  Future<void> play();

  /// Pauses playback on all active tracks.
  Future<void> pause();

  /// Resumes playback on all active tracks.
  Future<void> resume();

  /// Seeks to a specific duration in the audio track.
  Future<void> seek(Duration position);

  /// Stops and rewinds audio playback.
  Future<void> stop();

  /// Sets overall master volume (0.0 to 1.0).
  Future<void> setMasterVolume(double volume);

  /// Sets narration voice volume (0.0 to 1.0).
  Future<void> setNarrationVolume(double volume);

  /// Sets ambient background sound volume (0.0 to 1.0).
  Future<void> setAmbientVolume(double volume);

  /// Mutes or unmutes all audio playback.
  Future<void> setMuted(bool isMuted);

  /// Handles incoming audio interruptions (calls, alarms, voice assistant).
  Future<void> handleInterruption(AudioInterruptionAction action);

  /// Handles sudden audio route disconnection (e.g. unplugging wired or Bluetooth headphones).
  Future<void> handleHeadphonesDisconnected();

  /// Releases audio players, session focus, and memory resources.
  Future<void> dispose();
}
