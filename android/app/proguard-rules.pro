# Flavor Getter
-keep class com.example.yourPackageName.BuildConfig { *; }

# Firebase Messaging
-keep class io.flutter.plugins.firebase.messaging.** { *; }
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**