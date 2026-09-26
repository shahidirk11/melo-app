# Melo System Architecture

This document describes the high-level architecture, module decomposition, state management, navigation hierarchy, and design system contracts of the **Melo** application.

---

## 1. Architectural Overview

Melo follows a **Layered Domain-Driven Design (DDD)** combined with **Offline-First Reactive State Management**. The architecture strictly separates business rules from Flutter UI components to ensure zero-latency local operations, high testability, and deterministic behavior.

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                     │
│  Widgets · Screens · Stateful Shell · Responsive Containers │
└──────────────────────────────▲──────────────────────────────┘
                               │ Watches / Dispatches
┌──────────────────────────────┴──────────────────────────────┐
│                    Application State (Riverpod)             │
│   StateNotifiers · AsyncNotifiers · UI State Contracts      │
└──────────────────────────────▲──────────────────────────────┘
                               │ Calls
┌──────────────────────────────┴──────────────────────────────┐
│                        Domain Layer                         │
│  RecommendationEngine · ProgressAnalytics · BreathingMath   │
└──────────────────────────────▲──────────────────────────────┘
                               │ Reads / Persists
┌──────────────────────────────┴──────────────────────────────┐
│                         Data Layer                          │
│ Repositories · Models · Drift SQLite · SharedPreferences   │
└──────────────────────────────▲──────────────────────────────┘
                               │ Controls
┌──────────────────────────────┴──────────────────────────────┐
│                    Core Infrastructure & Services           │
│ AudioService · LocalNotifications · Connectivity · Logger   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Layer Responsibilities

### 2.1 Presentation Layer (`lib/features/`, `lib/shared/`)
* **Screens:** Top-level routed views (`HomeScreen`, `ExploreScreen`, `ProgressScreen`, `ProfileScreen`, `ActiveSessionScreen`).
* **Widgets:** Reusable, theme-aware atomic components (`MeloButton`, `MeloCard`, `MeloBottomSheet`, `BreathingCircleVisualizer`).
* **State Management:** Riverpod `StateNotifierProvider` connects the UI to business logic. The UI never interacts directly with low-level databases or audio hardware.

### 2.2 Domain Layer (`lib/features/*/domain/`)
* Contains **pure Dart business logic** completely free of Flutter UI dependencies:
  * `RecommendationEngine`: Local multi-factor deterministic scoring based on mood, time of day, goals, and history.
  * `ProgressAnalytics`: Streak calculations, active days, session minutes, and non-punitive gentle streak evaluation.
  * `BreathingCalculator`: Cycle timing, phase transitions, and visual expansion curves.

### 2.3 Data Layer (`lib/data/`)
* **Models:** Immutable data representations (`Session`, `SessionRecord`, `MoodEntry`, `ReminderSchedule`, `UserPreferences`).
* **Repositories:** Abstract interfaces with concrete implementations handling caching, serialization, and disk persistence.
* **Storage Engines:** Dual-layer persistence via SQLite (`drift`) for structured relational data and `shared_preferences` for instantaneous JSON document state.

### 2.4 Core Services (`lib/core/services/`)
* **AudioService (`lib/core/services/audio/`):** Abstraction over `just_audio` and `audio_session`, managing dual audio streams (narration + ambient), focus loss, headphone disconnects, and lock screen media sessions.
* **NotificationService (`lib/core/services/notification_service.dart`):** Abstraction over `flutter_local_notifications`, managing daily reminders, snooze schedules, and deep links.
* **ConnectivityService (`lib/core/services/connectivity_service.dart`):** Monitors network state while enforcing local-first fallbacks.

---

## 3. Navigation Hierarchy & Routing

Melo utilizes **GoRouter** with a nested `StatefulShellRoute.indexedStack` to maintain state across bottom navigation tabs while allowing dedicated full-screen experiences outside the shell:

```
AppRoutes.splash ('/')
   │
   ├──> AppRoutes.onboarding ('/onboarding') [First-run only]
   │
   ├──> AppShellScreen (StatefulShellRoute.indexedStack)
   │     ├── Tab 0: AppRoutes.home ('/home')
   │     ├── Tab 1: AppRoutes.explore ('/explore')
   │     ├── Tab 2: AppRoutes.progress ('/progress')
   │     └── Tab 3: AppRoutes.profile ('/profile')
   │
   └──> Full-Screen Overlays (Outside Shell)
         ├── AppRoutes.session ('/session/:id')
         ├── AppRoutes.sessionComplete ('/session/:id/complete')
         └── AppRoutes.profileReminders ('/profile/reminders')
```

### Deep Linking Support
* **Scheme:** `melo://` (e.g. `melo://session/session_1m_reset`)
* **Universal App Links:** `https://melo.app/session/:id`
* **Handling:** Injected via `MeloApp._initNotificationHandling` and GoRouter initial routing.

---

## 4. Design System Architecture

Melo adheres to an original, organic visual identity built from foundational tokens:

* **AppColors (`lib/app/theme/app_colors.dart`):**
  * Light Warm Canvas: `#F7F6F1`, Card Surface: `#FFFFFF`, Deep Text: `#1E2722`.
  * Dark True-Dark Canvas: `#131915`, Dark Surface: `#1C2420`, Dark Text: `#EBEFEA`.
  * Primary Forest Green: `#2D5A43`, Soft Sage Accent: `#8CAE99`.
  * Mood Tones: Calm Blue (`#7A9A95`), Good Sage (`#88A886`), Stressed Coral (`#D98880`).
* **AppTypography (`lib/app/theme/app_typography.dart`):**
  * Headings: Serif display font (Georgia/Merriweather fallback) for a warm, literary, contemplative feel.
  * Body & Controls: Clean geometric sans-serif with high legibility and full text-scaling support.
* **AppSpacing (`lib/app/theme/app_spacing.dart`):**
  * Grid system based on 4px/8px increments.
  * Corner radii: Soft rounded curves (`12px` cards, `20px` dialogs, `28px` bottom sheets).
  * Minimum touch targets: Enforced `48x48px` minimum bounding box across all interactives (WCAG 2.1 AAA).
* **Reduced Motion:**
  * When `reducedMotion == true`, animation durations are clamped and spring physics are replaced with subtle instant crossfades.
