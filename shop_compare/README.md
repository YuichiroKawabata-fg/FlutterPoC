# Shop Compare

Prototype Flutter app for comparing product prices across multiple shops.

The search feature now queries both Yahoo Shopping and Rakuten Ichiba APIs
using sample credentials included in the source. For production builds it is
recommended to provide `YAHOO_CLIENT_ID`, `RAKUTEN_APP_ID` and
`RAKUTEN_AFFILIATE_ID` environment variables and inject them at build time.

To fetch dependencies run:
```
flutter pub get
```

If you encounter an Android NDK version mismatch error during `flutter run`,
add the following to `android/app/build.gradle.kts` and ensure the required NDK
version is installed:

```kotlin
android {
    ndkVersion = "27.0.12077973"
}
```
