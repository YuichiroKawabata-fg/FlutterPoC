# Flutter Proof of Concept

This repository contains small Flutter prototypes. The primary demo is the **Shop Compare** app located in the `shop_compare` directory. It allows you to search for products and compare prices across shops.

## Running the app

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and ensure a device or emulator is available.
2. Navigate to the `shop_compare` directory.
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Launch the application:
   ```bash
   flutter run
   ```

When launched, the app opens to a **product search screen** where you can enter an item name.

## Directory overview

- `shop_compare` – product search and price comparison prototype.

## Troubleshooting

If the build fails with a message similar to:

```
Build failed due to use of deleted Android v1 embedding.
```

Your Flutter SDK is newer than some of the plugins used in this project. Run:

```bash
flutter pub upgrade
```

to fetch compatible plugin versions. Afterwards try `flutter run` again.

