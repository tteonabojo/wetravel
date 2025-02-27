# Flutter 관련 ProGuard 규칙
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Kotlin 관련 규칙
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# Firebase 관련 규칙 (Firebase 사용 시)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# 기타 필요한 규칙
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
