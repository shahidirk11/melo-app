# Melo Testing & Quality Assurance Guide

This document details the test strategy, execution instructions, 27-flow E2E test matrix, and static verification scripts for the **Melo** application.

---

## 1. Testing Philosophy

Melo employs a multi-tiered quality assurance strategy ensuring zero unhandled exceptions, zero data loss, WCAG AAA accessibility, and robust offline behavior.

```
                    ┌─────────────────────────┐
                    │  27-Flow E2E Suite      │  Integration Testing
                    │  (All core journeys)    │
                    ├─────────────────────────┤
                    │  Widget & UX Suites     │  Screen & Accessibility Testing
                    │  (Visual & Interaction) │
                    ├─────────────────────────┤
                    │  Unit & Domain Tests    │  Pure Deterministic Business Logic
                    │  (Analytics & Scoring)  │
                    ├─────────────────────────┤
                    │  Static QA Runner       │  AST Balance, Imports, WCAG Contrast
                    └─────────────────────────┘
```

---

## 2. Test Suite Directory Structure

```
test/
├── integration/
│   └── comprehensive_e2e_flows_test.dart    # Full 27-flow end-to-end integration suite
├── unit/
│   ├── recommendation_engine_test.dart       # Deterministic scoring unit tests
│   ├── session_engine_test.dart              # Session state machine tests
│   ├── progress_analytics_test.dart          # Streak and statistics tests
│   ├── breathing_pattern_test.dart           # Breathing cycle phase calculations
│   ├── audio_service_test.dart               # Audio session & interruption tests
│   └── repository_tests/                     # Persistence & JSON serialization tests
├── widget/
│   ├── home_screen_test.dart                 # Greeting, check-in, recommendation
│   ├── explore_screen_test.dart              # Filtering, search, favorites
│   ├── active_session_screen_test.dart       # Session player controls & timer
│   ├── progress_screen_test.dart             # Charts and streak banners
│   ├── profile_screen_test.dart              # Settings, appearance, and export
│   └── ux_visual_polish_test.dart            # Dark mode, typography, touch targets
└── qa_verification_runner.js                 # Zero-dependency automated QA engine
```

---

## 3. The 27-Flow Verification Matrix

The test suite in [`test/integration/comprehensive_e2e_flows_test.dart`](file:///c:/Users/Shahzad/Downloads/ShahidFx%20Meditation%20App/test/integration/comprehensive_e2e_flows_test.dart) tests all 27 distinct product flows:

1. **Fresh Install:** Validates first-run routing to Onboarding when `onboardingCompleted == false`.
2. **Onboarding Flow:** Advances through Goals, Duration, Daily Time, Reminders, and First Session.
3. **Returning User:** Verifies returning users bypass onboarding and land immediately on Home.
4. **Mood Check-in:** Logs moods (*Calm*, *Good*, *Okay*, *Stressed*, *Tired*) and persists locally.
5. **Home Recommendation Engine:** Scores sessions based on mood, time of day, goals, and history.
6. **Explore:** Tests category-based browsing across all 8 mindful categories.
7. **Search:** Executes client-side multi-field search across title, description, and tags.
8. **Favorites:** Toggles favorite state with instant local persistence.
9. **Meditation Session:** Boots active session state machine with timers and visualizers.
10. **Pause / Resume:** Synchronizes timers, state transitions, and audio playback.
11. **Session Completion:** Triggers completion state and records session to history.
12. **Reflection:** Logs post-session mood change (`moreRelaxed`, `moreFocused`, etc.).
13. **Progress:** Calculates total sessions, mindful minutes, and active days.
14. **History:** Displays reverse-chronological practice logs with duration badges.
15. **Gentle Streak:** Validates non-punitive gentle streak logic (tolerates same day or yesterday).
16. **Reminder Creation:** Schedules custom reminder times and active days of week.
17. **Notification Permission:** Tests two-stage educational sheet prior to OS permission dialog.
18. **Notification Deep Link:** Verifies notification payloads route directly into sessions.
19. **Settings:** Persists mindfulness preferences, goals, and durations across app runs.
20. **Dark Mode:** Verifies dynamic theme switching with WCAG AAA contrast compliance.
21. **Reduced Motion:** Clamps animation curves when accessibility reduced motion is enabled.
22. **Offline Mode:** Tests 100% operation with network connectivity completely disconnected.
23. **Audio Fallback:** Tests seamless text-guidance fallback when audio files are absent.
24. **App Restart:** Rehydrates repository state from disk without data loss.
25. **Backgrounding:** Validates state persistence across OS app lifecycle pauses.
26. **Session Interruption:** Pauses playback safely on phone calls and headphone unplugging.
27. **Error States:** Renders graceful `ErrorView` with retry actions on bad session IDs.

---

## 4. How to Execute Tests

### 4.1 Running All Flutter Tests
```bash
flutter test
```

### 4.2 Running the E2E Integration Suite
```bash
flutter test test/integration/comprehensive_e2e_flows_test.dart
```

### 4.3 Running the Zero-Dependency QA Verification Suite
```bash
node test/qa_verification_runner.js
```
*Output verifies:*
* All 141 production Dart files have valid syntax and balanced brackets.
* Zero broken imports across all layers.
* Light mode text contrast ratio $\ge 14:1$ (exceeds WCAG AAA 7.0:1).
* Dark mode text contrast ratio $\ge 15:1$ (exceeds WCAG AAA 7.0:1).
* Recommendation scoring correctness.
* Gentle streak day edge cases.
* Breathing pattern cycle mathematics.
