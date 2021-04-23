# Persona Inquiry for Flutter

[![pub](https://img.shields.io/pub/v/persona_flutter.svg)](https://pub.dev/packages/persona_flutter)
[![points](https://badges.bar/persona_flutter/pub%20points)](https://pub.dev/packages/persona_flutter)
[![popularity](https://badges.bar/persona_flutter/popularity)](https://pub.dev/packages/persona_flutter)
[![likes](https://badges.bar/persona_flutter/likes)](https://pub.dev/packages/persona_flutter)
[![donate](https://img.shields.io/badge/Buy%20me%20a%20beer-orange.svg)](https://www.buymeacoffee.com/jpereira)

Native implementation of the [Persona Inquiry flow](https://docs.withpersona.com/docs) for Flutter.

This plugin integrates the native SDKs:

- [Persona iOS SDK](https://sdk.withpersona.com/ios/docs/index.html)
- [Persona Android SDK](https://sdk.withpersona.com/android/docs/index.html)

Feel free to leave any feedback [here](https://github.com/jorgefspereira/persona_flutter/issues).

## Installation

Add `persona_flutter` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### iOS

You need to add the following key to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library.</string>
```

#### Requirements

- iOS 11.0 or later is required.
- Cocoapods 1.9.3 has a bug that prevents builds from selecting the correct architecture. See more details [here.](https://github.com/CocoaPods/CocoaPods/pull/9790) Please downgrade to 1.8.x or upgrade to 1.10.x

### Android

Change the minimum Android sdk version to 21 (or higher) in your `android/app/build.gradle` file.

```
minSdkVersion 21
```

#### Theming

Using the `styles.xml` of your app, you can set colors, buttons and more to customize the Persona flow to your own style. Just extend the base Persona style `Base.Persona.Inquiry.Theme` and name it `Persona.Inquiry.Theme`.

```xml
<style name="Persona.Inquiry.Theme" parent="@style/Base.Persona.Inquiry.Theme">
    <item name="colorPrimary">#22CB8E</item>
    <item name="colorAccent">#22CB8E</item>
    <item name="colorPrimaryDark">#167755</item>
</style>
```