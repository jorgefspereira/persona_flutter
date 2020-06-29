# Persona Inquiry for Flutter

[![pub](https://img.shields.io/pub/v/persona_flutter.svg)](https://pub.dev/packages/persona_flutter)

Native implementation of the [Persona Inquiry flow](https://docs.withpersona.com/docs) for Flutter.

This plugin integrates the native SDKs:

- [Persona iOS SDK](https://sdk.withpersona.com/ios/docs/index.html)
- [Persona Android SDK](https://sdk.withpersona.com/android/docs/index.html)

If you like this plugin and find it useful, I would be forever grateful for your support:

<a href="https://www.buymeacoffee.com/jpereira" target="_blank"><img width="140" src="https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png" alt="Buy Me A Coffee"></a>

Feel free to leave any feedback [here](https://github.com/jorgefspereira/persona_flutter/issues).

## Installation

Add `persona_flutter` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### iOS

You need to add the following key to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Can I use the camera please?</string>
```

**Note:** iOS 11.0 or later is required.

### Android

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```
minSdkVersion 21
```

## TODOs

- [ ] Support for replacement strings customization
- [ ] Support for custom styling
- [ ] Implement tests