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
