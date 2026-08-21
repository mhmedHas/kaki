# Keep rules for printer SDKs
-keep public class com.gengcon.www.jcprintersdk.** { *; }
-keep public class com.niimbot.canvas.image.** { *; }
-keep public class com.dothantech.** { *; }
-keep public class zpSDK.zpSDK.** { *; }
-keep public class com.snbc.sdk.** { *; }
-keep public class android_serialport_api.** { *; }

# Ignore warnings
-dontwarn com.gengcon.www.jcprintersdk.**
-dontwarn com.jingchen.jcimagesdk.**
-dontwarn com.niimbot.canvas.image.**
-dontwarn com.dothantech.**
-dontwarn zpSDK.zpSDK.**
-dontwarn com.snbc.sdk.**
-dontwarn android_serialport_api.*


# =========================
# Seuic UHF RFID SDK
# =========================

# Keep all UHF classes (reflection based)
#-keep class com.seuic.uhf.** { *; }

# Keep EPC model
#-keep class com.seuic.uhf.EPC { *; }

# Do not warn about UHF sdk internals
#-dontwarn com.seuic.uhf.**
