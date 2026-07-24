# White-Label App Setup Guide

How to create a new white-label app using `soliplex_frontend`.
This repo (Theme Template) serves as the reference implementation.

## Overview

A white-label app is a thin wrapper around `soliplex_frontend`. You provide:

- **Branding** (icons, splash images, colors)
- **Configuration** (`standard()` flavor in `main.dart`)
- **Web scaffold** (`web/index.html`, `web/manifest.json`)
- **Platform configs** (bundle IDs, signing, entitlements)

All core functionality (chat, history, settings, auth) comes from the library.

## 1. Create the Flutter Project

```bash
flutter create --org com.example my_app
cd my_app
```

## 2. Add soliplex\_frontend Dependency

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  soliplex_frontend:
    git:
      url: https://github.com/soliplex/frontend.git
      ref: v0.80.0+28  # pin to a release tag

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.14.4
  flutter_native_splash: ^2.4.5
```

Then fetch dependencies:

```bash
flutter pub get
```

## 3. Write the Entry Point

Replace `lib/main.dart` with a call to `standard()` and `runSoliplexShell()`.
All fields except `appName` have defaults — only set what you need to override.

```dart
import 'package:flutter/material.dart';
import 'package:soliplex_frontend/flavors.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final callbackParams = CallbackParamsCapture.captureNow();
  clearCallbackUrl();
  final config = await standard(
    appName: 'My App',
    redirectScheme: 'com.example.myapp',
    defaultBackendUrl: 'https://api.example.com',
    logo: Image.asset(
      'assets/branding/my_app/app_icon_1024.png',
      width: 64,
      height: 64,
    ),
  );
  runSoliplexShell(config);
}
```

### `standard()` Parameters

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `appName` | `String` | `'Soliplex'` | Display name |
| `defaultBackendUrl` | `String` | `'http://localhost:8000'` | Backend API URL |
| `redirectScheme` | `String` | `'ai.soliplex.client'` | OAuth redirect scheme |
| `logo` | `Widget?` | `null` | App logo widget |
| `consentNotice` | `ConsentNotice?` | `null` | Consent banner |
| `theme` | `ThemeData?` | `null` | Custom theme |
| `callbackParams` | `CallbackParams` | `NoCallbackParams()` | OAuth callbacks |

### Consent Notice (Optional)

If your app requires a consent or terms-of-use banner shown before the chat
loads, create a separate file and pass it via `consentNotice`. The body
supports markdown.

`ConsentNotice` must be imported directly — it is not in the barrel file:

```dart
import 'package:soliplex_frontend/src/modules/auth/consent_notice.dart';
```

## 4. Branding Assets

### Source Images

Every platform icon and splash is generated from just **five raster masters plus
one SVG**. The generators do **not** accept SVG, so export raster PNGs from your
vector logo. Place them in `assets/branding/<app_name>/`:

| File | Size | Alpha | Content / safe-zone | Drives |
| ---- | ---- | ----- | ------------------- | ------ |
| `app_icon.png` | 1024x1024 | opaque | Full-bleed mark on brand background | iOS (light), macOS, Windows, web icons + favicon, Android legacy |
| `app_icon_ios_dark.png` | 1024x1024 | transparent | Mark only (iOS composites its own dark backdrop) | iOS dark home-screen icon |
| `adaptive_foreground.png` | 1024x1024 | transparent | Logo inside inner ~66% (adaptive mask safe-zone) | Android adaptive foreground |
| `splash.png` | 1152x1152 | transparent | Light logo inside a 768px circle (Android 12 clips to a circle) | Splash (light), legacy + Android 12 |
| `splash_dark.png` | 1152x1152 | transparent | Dark-mode (light-colored) logo, same circle | Splash (dark), legacy + Android 12 |
| `favicon.svg` | vector | — | Brand mark; copy into `web/favicon.svg` | Web `<link rel="icon">` (see §5) |

What is shared: one `app_icon.png` covers five platforms; one `splash.png`/
`splash_dark.png` pair covers every splash. Backgrounds are hex colors, never
images. You effectively maintain one logo plus your brand colors.

Register the asset directory in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/branding/my_app/
```

### Icon and Splash Generation

Configure `flutter_launcher_icons` and `flutter_native_splash` in
`pubspec.yaml`. Only real config keys are shown below — note there is **no
`web_favicon_path`** key (the web favicon is always `image_path` downscaled to
16px), and the iOS dark icon key is `image_path_ios_dark_transparent`:

```yaml
flutter_launcher_icons:
  image_path: "assets/branding/my_app/app_icon.png"
  android: true
  min_sdk_android: 21
  adaptive_icon_foreground: "assets/branding/my_app/adaptive_foreground.png"
  adaptive_icon_background: "#ffffff"
  ios: true
  image_path_ios_dark_transparent: "assets/branding/my_app/app_icon_ios_dark.png"
  remove_alpha_ios: true
  background_color_ios: "#ffffff"
  web:
    generate: true
    background_color: "#ffffff"
    theme_color: "#0A7AFF"
  macos:
    generate: true
  windows:
    generate: true
    icon_size: 256

flutter_native_splash:
  color: "#ffffff"
  image: "assets/branding/my_app/splash.png"
  color_dark: "#1d1f23"
  image_dark: "assets/branding/my_app/splash_dark.png"
  android_12:
    color: "#ffffff"
    image: "assets/branding/my_app/splash.png"
    color_dark: "#1d1f23"
    image_dark: "assets/branding/my_app/splash_dark.png"
  android: true
  ios: true
  web: true
```

Then generate:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

This produces platform-specific icons in `android/`, `ios/`, `macos/`,
`windows/`, `web/icons/` (plus `web/favicon.png`), and splash images in
`web/splash/`.

## 5. Web Scaffold

The `web/` directory is not part of `soliplex_frontend` — each app maintains
its own. Two files need customization.

### web/index.html

Key things to customize (search for `Theme Template` and `#ffffff` as reference):

- **`<meta name="description">`** — your app description
- **`<meta name="apple-mobile-web-app-title">`** — your app name
- **`<title>`** — your app name
- **`background-color`** in the `<style>` block — your brand background color

The `removeSplashFromWeb()` function cleans up all splash elements once
Flutter takes over.

### web/manifest.json

Set `background_color` to match your body background to prevent a color
flash on load:

```json
{
  "name": "My App",
  "short_name": "My App",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#0175C2",
  "description": "My App description",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "icons/Icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

### web/flutter\_bootstrap.js

A custom bootstrap that adds a loading progress bar. The key constraint is
compatibility with `post-build-cache-bust.sh`, which uses sed to replace
the bare `_flutter.loader.load()` call with one that passes a `config`
object for cache-busted asset paths.

The bootstrap wraps `_flutter.loader.load` before calling it, so the actual
call site stays bare for sed to match:

```javascript
// Wrap loader to inject onEntrypointLoaded
(function() {
  const nativeLoad = _flutter.loader.load.bind(_flutter.loader);
  _flutter.loader.load = function(options) {
    return nativeLoad(Object.assign({
      onEntrypointLoaded: async function(engineInitializer) { /* ... */ }
    }, options));
  };
})();

_flutter.loader.load()
```

`Object.assign` puts `onEntrypointLoaded` as the default, then overlays
whatever `options` sed injects (which contains only `config`). The result
has both the progress callbacks and the cache-bust config.

The HTML elements `#loading-status`, `#progress-track`, and `#progress-bar`
are defined in `index.html` and cleaned up by `removeSplashFromWeb()`.

## 6. Platform Setup

### iOS

#### Code Signing

Create the xcconfig template and gitignore pattern:

```bash
# Create template
cat > ios/Runner/Configs/Local.xcconfig.template << 'EOF'
// Local development settings - Copy to Local.xcconfig (gitignored)
//
// Your Apple Developer Team ID (10-character alphanumeric)
// Find it at: https://developer.apple.com/account -> Membership details
// Uncomment and fill in:
// DEVELOPMENT_TEAM = XXXXXXXXXX
EOF

# Developer setup
cp ios/Runner/Configs/Local.xcconfig.template ios/Runner/Configs/Local.xcconfig
# Edit Local.xcconfig and uncomment DEVELOPMENT_TEAM with your ID
```

Ensure `**/Local.xcconfig` is in `.gitignore`.

- **Simulator:** Works without `Local.xcconfig` for debug builds.
- **Physical device:** Requires `Local.xcconfig` with a valid
  `DEVELOPMENT_TEAM`.

#### Export Compliance

Add to `ios/Runner/Info.plist` inside the `<dict>` block to skip the export
compliance prompt on App Store uploads:

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

#### Privacy Descriptions (Info.plist)

The `file_picker` dependency links against `Photos.framework`, so iOS requires
`NSPhotoLibraryUsageDescription` in `ios/Runner/Info.plist`. This is already
configured — if you add new plugins that access protected resources (camera,
microphone, location, etc.), add the corresponding `NS*UsageDescription` keys.

#### CocoaPods

```bash
cd ios && pod install && cd ..
```

### macOS

Same xcconfig pattern as iOS:

```bash
cp macos/Runner/Configs/Local.xcconfig.template macos/Runner/Configs/Local.xcconfig
# Edit and set DEVELOPMENT_TEAM
cd macos && pod install && cd ..
```

macOS code signing is required for Keychain access (secure token storage).
Without it, the app runs but auth tokens don't persist across restarts.

### Android

No special setup required. Ensure internet permission is in
`AndroidManifest.xml` (Flutter includes it by default).

## 7. Running

```bash
flutter run -d chrome    # Web
flutter run -d macos     # macOS
flutter run -d ios       # iOS simulator
flutter run -d android   # Android emulator
```

### Android emulator and a local backend

Inside the emulator, `127.0.0.1` is the emulator itself, not your machine,
so a backend at `http://127.0.0.1:8000` is unreachable by default. Forward
the port before connecting:

```bash
adb reverse tcp:8000 tcp:8000
```

The app can then use `http://127.0.0.1:8000` unchanged — and because Android
exempts loopback addresses from its cleartext-HTTP block, plain `http://`
works without manifest changes. Re-run the command after restarting the
emulator or adb; the forward does not persist.

(The alternative host alias `http://10.0.2.2:8000` needs no adb command but
is not loopback from the device's perspective, so plain HTTP would require
`android:usesCleartextTraffic="true"` in `AndroidManifest.xml`.)

## Troubleshooting

### Entitlements require signing

```text
"Runner" has entitlements that require signing with a development certificate
```

**Fix:** Create `Local.xcconfig` with `DEVELOPMENT_TEAM` as described above.

### Keychain errors on macOS (OSStatus -25293)

**Cause:** Missing or invalid code signing configuration.

**Fix:** Follow the macOS code signing setup above.

### Pod install fails

```bash
cd ios && pod deintegrate && pod install && cd ..
cd macos && pod deintegrate && pod install && cd ..
```
