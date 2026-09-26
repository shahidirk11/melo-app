# Melo 🌿

> *Your little daily reset.*

Melo is a modern, calm, and distraction-free mobile mindfulness and meditation companion built with Flutter. Designed with an offline-first mindset, Melo empowers users to pause, breathe, and reset without subscriptions, ads, gamified guilt, or aggressive streak shaming.

---

## ✨ Features at a Glance

* **Time-Aware Greeting & Check-In:** Greets users based on local time and captures current mood (*Calm*, *Good*, *Okay*, *Stressed*, *Tired*).
* **Deterministic Local Recommendation Engine:** Suggests personalized resets based on mood, time of day, goals, and history—100% locally with zero cloud dependence.
* **Production Session Engine:** Reusable session state machine (`IDLE` $\to$ `PLAYING` $\to$ `PAUSED` $\to$ `COMPLETED`) with smooth animated breathing visualizers and audio synchronization.
* **Configurable Breathing Patterns:** Box breathing (4-4-4-4), relaxing breath (4-7-8), and simple slow breathing with reduced-motion support.
* **Dual-Channel Audio Architecture:** Simultaneous guided narration and ambient soundscapes with automatic fallback to text guidance when audio is unavailable.
* **Explore & Search:** Local-first search across titles, descriptions, and tags with multi-category filtering (*Calm*, *Focus*, *Sleep*, *Morning*, *Breathing*, *Beginner*, *Stress Reset*, *Relaxation*) and favorites persistence.
* **Non-Competitive Progress & Gentle Streak:** Tracks total sessions, mindful minutes, and gentle streaks (*"7 days of showing up 🌱"*) without shaming or anxiety-inducing mechanics.
* **Mindful Reminders & Deep Linking:** Scheduled local notifications with supportive copy and instant deep-linking into specific practice sessions.
* **Profile & Settings:** Theme switching (System, Light, Dark), reduced motion, gentle haptic toggles, local data export, and clear data controls.
* **100% Local-First & Private:** All session records, moods, favorites, and settings remain securely on your device.

---

## 🛠 Tech Stack

* **Framework:** Flutter 3.19+ (Dart 3.3+)
* **State Management:** Riverpod 2.5+ (`flutter_riverpod`)
* **Navigation:** GoRouter 14.2+ with branch shell routes and deep linking
* **Persistence:** SQLite/Drift (`drift`, `sqlite3_flutter_libs`) & `shared_preferences`
* **Audio:** `just_audio` & `audio_session` with foreground media playback
* **Notifications:** `flutter_local_notifications`
* **Accessibility:** WCAG 2.1 AAA contrast compliance (≥ 7.0:1) with full text scaling and reduced motion compatibility

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your development machine:
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.19.0 or higher)
* [Android Studio](https://developer.android.com/studio) / Android SDK (API 34)
* Java Development Kit (JDK 17)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/melo/melo_app.git
   cd melo_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (if modifying Drift tables):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

Run the full automated test suite:
```bash
# Run unit and widget tests
flutter test

# Run static analysis
flutter analyze

# Run the 27-flow E2E integration test suite
flutter test test/integration/comprehensive_e2e_flows_test.dart

# Run the zero-dependency automated QA verification suite
node test/qa_verification_runner.js
```

---

## 📦 Building for Production

### Android

```bash
# Build release APK
flutter build apk --release

# Build Google Play App Bundle (.aab)
flutter build appbundle --release
```

*For keystore setup and release signing instructions, consult [`docs/RELEASE.md`](docs/RELEASE.md).*

---

## 📚 Documentation Index

* [Architecture & System Design](docs/ARCHITECTURE.md)
* [Database & Persistence](docs/DATABASE.md)
* [Audio Architecture & Fallbacks](docs/AUDIO_SYSTEM.md)
* [Notifications & Reminders](docs/NOTIFICATIONS.md)
* [Testing Strategy & QA Matrix](docs/TESTING.md)
* [Production Release Guide](docs/RELEASE.md)

---

## 📄 Wellness Disclaimer

*Melo is designed to support daily mindfulness, breathing exercises, and relaxation. It is not intended to diagnose, treat, cure, or replace professional medical or mental health care.*
