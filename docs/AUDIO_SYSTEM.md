# Melo Audio System & Architecture

This document describes the design, playback mechanics, native session handling, and graceful fallback behavior of the **Melo** audio system.

---

## 1. Overview & Architectural Decoupling

The audio architecture in Melo is fully decoupled from the UI layer via the abstract interface `AudioService` (`lib/core/services/audio/audio_service.dart`). The presentation layer interacts exclusively with the service interface, enabling:
* Effortless unit testing via `InMemoryAudioService` with zero hardware dependencies.
* Safe swaps or upgrades to the underlying audio engine without breaking the session state machine.
* Automatic text-guided fallback when assets are unavailable or silent mode is preferred.

```
┌────────────────────────────────────────────────────────┐
│                   ActiveSessionScreen                  │
│                     (UI Presenter)                     │
└───────────────────────────┬────────────────────────────┘
                            │ Calls play/pause/seek
┌───────────────────────────▼────────────────────────────┐
│                  SessionEngineNotifier                 │
│               (State Machine Controller)               │
└───────────────────────────┬────────────────────────────┘
                            │ Dispatches
┌───────────────────────────▼────────────────────────────┐
│                    AudioService (Interface)            │
└──────────────┬──────────────────────────┬──────────────┘
               │                          │
       ┌───────▼────────┐        ┌────────▼────────┐
       │ JustAudioService│       │ InMemoryAudio   │
       │ (Production)   │        │ (Unit Tests/QA) │
       └───────┬────────┘        └─────────────────┘
               │
   ┌───────────▼───────────┐
   │  Dual Playback Engine │
   │  • Guided Narration   │
   │  • Ambient Soundscape │
   └───────────────────────┘
```

---

## 2. Dual-Channel Playback Engine

Melo provides simultaneous dual-channel audio:
1. **Guided Narration Player:**
   * Plays voice instruction and guidance cues.
   * Dynamic speed control (1.0x default).
2. **Ambient Soundscape Player:**
   * Plays serene looping ambient audio (e.g. gentle rain, soft bells, forest breeze).
   * Independent volume attenuation relative to voice guidance.

---

## 3. Native Audio Session & Interruption Handling

Melo integrates with `audio_session` to ensure polite coexistence with the host operating system:

### 3.1 Audio Focus Configuration
* **Android / iOS Category:** `AudioCategory.playback`
* **Options:** `duckOthers` enabled so ambient sounds gently dip when navigation apps or notifications chime.

### 3.2 Interruption Handling
* **Incoming Phone Calls / Alarms:**
  When audio focus is lost (`AudioInterruptionAction.pause`), the playback pauses immediately and synchronizes the session timer.
  When the call terminates and focus is regained (`AudioInterruptionAction.resume`), playback and timing resume smoothly.
* **Headphone Disconnection (Becoming Noisy):**
  Unplugging wired headphones or disconnecting Bluetooth headphones immediately triggers `handleHeadphonesDisconnected()`, pausing the session instantly to prevent abrupt loudspeaker playback.

### 3.3 Background Audio Playback
* Configured via Android `FOREGROUND_SERVICE_MEDIA_PLAYBACK` permission and lock screen controls.
* Users can toggle background playback in **Settings $\to$ Audio Settings $\to$ Background audio playback**.

---

## 4. Graceful Text-Guidance Fallback

A core requirement of Melo is that **no session may fail or crash because an audio file is missing or corrupted**.

```
Audio Preparation Request
          │
          ▼
Asset Existence Check
   ├── Exists ─────────> Load Narration & Ambient Streams
   │
   └── Not Found ──────> Engage Silent Fallback Mode:
                         • isFallbackMode = true
                         • Timers and visual breathing remain 100% active
                         • Text guidance prompts step through in sync
                         • Zero crashes, zero blank screens
```

When running in demo or fallback mode:
* The active session UI clearly displays guidance prompts on screen.
* The breathing circle visualizer expands and contracts on schedule.
* Elapsed and remaining timers continue with millisecond accuracy.
* Post-session completion and reflection logging remain fully functional.

---

## 5. Development & Demo Assets

Bundled royalty-free demonstration assets are provided in `assets/audio/`:
* `demo_narration.wav`: Gentle intro cue for guided sessions.
* `demo_ambient.wav`: Serene looping tone for background mindfulness.
* `demo_bell.wav`: Clean chime marking session start and end.
