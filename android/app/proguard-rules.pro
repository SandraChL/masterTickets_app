# Stripe
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.**

# Stripe Push Provisioning
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

# React Native Stripe SDK (usado internamente por flutter_stripe)
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**
