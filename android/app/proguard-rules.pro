# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Drift / SQLite rules
-keepnames class * extends androidx.room.RoomDatabase
-keep class * extends androidx.room.RoomDatabase { *; }

# Just Audio & Audio Session
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audiosession.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
