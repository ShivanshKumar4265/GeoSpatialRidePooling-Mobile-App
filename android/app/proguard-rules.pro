# Firebase Core
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Flutter & Pigeon (platform channels)
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Keep all plugin registrant classes
-keep class io.flutter.plugin.** { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }