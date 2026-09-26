# Melo Notifications & Mindful Reminders

This document describes the reminder system architecture, notification channels, permission handling, deep linking, and supportive copy guidelines for the **Melo** application.

---

## 1. Notification Philosophy: Supportive, Not Coercive

Melo rejects the aggressive, guilt-based engagement notifications common in modern mobile apps. Reminders are designed as gentle invitations to take a quiet breath, never as guilt triggers.

### Copy Guidelines

| Good Supportive Copy 🌿 | Disallowed Guilt / Fear Copy ❌ |
|---|---|
| *"A small reset might feel good right now."* | *"You haven't meditated today!"* |
| *"Ready for your evening wind-down?"* | *"Don't break your streak!"* |
| *"Take two minutes just for yourself."* | *"You're falling behind on your goals."* |
| *"Your afternoon pause is waiting whenever you are."* | *"Hurry! 1 hour left to keep your streak!"* |

---

## 2. Notification Channels (Android)

Melo registers a dedicated notification channel:
* **Channel ID:** `melo_mindful_reminders`
* **Channel Name:** `Mindful Reminders`
* **Channel Description:** `Gentle, supportive notifications for mindfulness and breathing.`
* **Importance:** `Importance.high`
* **Priority:** `Priority.high`
* **Vibration:** Enabled with gentle, non-jarring pattern.

---

## 3. Educational Permission Flow

To avoid user fatigue and high rejection rates, Melo never triggers the system permission dialog cold. Instead, it follows a two-tier educational flow:

```
User visits Reminders or Onboarding Step 4
                      │
                      ▼
       Educational Pre-Permission Sheet
    (Explains frequency, quiet tone, and benefits)
                      │
        ┌─────────────┴─────────────┐
        │                           │
  "Maybe later"           "Enable reminders"
  (Dismisses sheet)                 │
                                    ▼
                     Native System Permission Dialog
                    (POST_NOTIFICATIONS / iOS Prompt)
```

---

## 4. Reminder Scheduling Mechanics

Managed via `LocalNotificationService` (`lib/core/services/notification_service.dart`):

* **Configurable Slots:**
  * Morning (default 08:00)
  * Afternoon (default 14:00)
  * Evening (default 21:00)
  * Custom time (user-selected hour and minute)
* **Active Days Selection:** Users can choose weekdays only, weekends, everyday, or custom day subsets (Monday through Sunday).
* **Snooze Support:** Users can snooze an active reminder for 15 minutes without disrupting their recurring weekly schedule.
* **Persistent Recovery:** `ScheduledNotificationBootReceiver` is registered in `AndroidManifest.xml` to re-register alarms automatically when the device restarts.

---

## 5. Deep Linking & Routing

Tapping a notification immediately deep-links the user into the relevant experience rather than dumping them at an ambiguous landing screen:

```
User Taps Notification
          │
          ▼
`LocalNotificationService.initialize(onNotificationTapped: ...)`
          │
          ▼
`router.go(payload)`
          ├── '/session/session_1m_reset' ──> Direct to Active Session Player
          └── '/home'                     ──> Direct to Home Daily Reset
```

### Deep Link Schemes
* **Custom Scheme:** `melo://session/:id` (e.g. `melo://session/session_5m_breath`)
* **Universal App Links:** `https://melo.app/session/:id`
