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

Place source images in `assets/branding/<app_name>/`:

| File | Size | Purpose |
| ---- | ---- | ------- |
| `app_icon_1024.png` | 1024x1024 | App icon and in-app logo |
| `favicon_48.png` | 48x48 | Web favicon |
| `splash_1024.png` | 1024x1024 | Splash screen image |
| `adaptive_foreground.png` | 1024x1024 | Android adaptive icon foreground |
| `android12_splash.png` | 1024x1024 | Android 12+ splash |

Register the asset directory in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/branding/my_app/
```

### Icon and Splash Generation

Configure `flutter_launcher_icons` and `flutter_native_splash` in
`pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  remove_alpha_ios: true
  macos:
    generate: true
  web:
    generate: true
  windows:
    generate: true
  image_path: "assets/branding/my_app/app_icon_1024.png"
  web_favicon_path: "assets/branding/my_app/favicon_48.png"
  adaptive_icon_foreground: "assets/branding/my_app/adaptive_foreground.png"
  adaptive_icon_background: "#ffffff"

flutter_native_splash:
  color: "#ffffff"
  image: "assets/branding/my_app/splash_1024.png"
  android_12:
    color: "#ffffff"
    image: "assets/branding/my_app/android12_splash.png"
  ios: true
  web: true
```

Then generate:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

This produces platform-specific icons in `android/`, `ios/`, `macos/`,
`web/icons/`, and splash images in `web/splash/`.

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
