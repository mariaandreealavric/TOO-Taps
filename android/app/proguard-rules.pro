# Mantieni le classi dell'API pubblica
-keep public class * {
    public protected *;
}

# Mantieni le classi e i metodi annotati con @Keep
-keep @androidx.annotation.Keep class * { *; }
-keep class * {
    @androidx.annotation.Keep <methods>;
}

# Mantieni le classi e i metodi annotati con @Parcelize
-keep @kotlinx.parcelize.Parcelize class * { *; }

# Mantieni le classi e i metodi utilizzati da Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Mantieni le classi richieste dalle librerie di terze parti
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
