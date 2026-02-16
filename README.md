# Persona Inquiry for Flutter

[![pub](https://img.shields.io/pub/v/persona_flutter.svg)](https://pub.dev/packages/persona_flutter)
[![likes](https://img.shields.io/pub/likes/persona_flutter)](https://pub.dev/packages/persona_flutter)
[![downloads](https://img.shields.io/pub/dm/persona_flutter)](https://pub.dev/packages/persona_flutter)
[![donate](https://img.shields.io/badge/Buy%20me%20a%20beer-orange.svg)](https://www.buymeacoffee.com/jpereira)

Native implementation of the [Persona Inquiry flow](https://docs.withpersona.com/docs) for Flutter.

This plugin integrates the native v2 SDKs:

- [Persona iOS v2 SDK](https://docs.withpersona.com/docs/ios-sdk-v2-integration-guide)
- [Persona Android v2 SDK](https://docs.withpersona.com/docs/android-sdk-v2-integration-guide)

Feel free to leave any feedback [here](https://github.com/jorgefspereira/persona_flutter/issues).

_Important: Persona stopped support for **v1** on December 31, 2022. If you need the older mobile integration, check the version **2.1.5** of this plugin or **v1** branch of this repository._

## Installation

Add `persona_flutter` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## iOS

#### Requirements

- iOS 13.0 or later is required.
- Update your `ios/Runner/Info.plist`:

  ```xml
  <key>NSCameraUsageDescription</key>
  <string>This app requires access to the camera.</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>This app requires access to the photo library.</string>
  ```

- **Optionally** if you need support for video, NFC verifications or GPS collections, add to your `ios/Runner/Info.plist`:

  ```xml
  <key>NSMicrophoneUsageDescription</key>
  <string>This app requires access to the microphone.</string>
  <key>NFCReaderUsageDescription</key>
  <string>This app requires access to the NFC.</string>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>This app requires access to the Location when in use.</string>
  ```

Note: Cocoapods 1.9.3 has a bug that prevents builds from selecting the correct architecture. See more details [here.](https://github.com/CocoaPods/CocoaPods/pull/9790) Please downgrade to 1.8.x or upgrade to 1.10.x

#### Privacy

The Persona SDK collects a user’s IDFV for fraud prevention purposes. In App Store Connect > Your App > App Privacy, if you haven’t already add in a “Device Identifier,” and fill out the questionnaire with the following answers:

- Usage: App Functionality (covers fraud prevention)
- Are the device IDs collected from this app linked to the user’s identity? Yes
- Do you or your third-party partners use device IDs for tracking purposes? No

Be sure to also update your privacy manifest according to the features you are making use of from the SDK. See our iOS [Privacy Manifest instructions](https://docs.withpersona.com/docs/ios-privacy-manifest) for more information.

## Android

#### Requirements

- Change the `minSdkVersion` to 21 (or higher) in your `android/app/build.gradle` file.
- Declare the following permissions:

  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.INTERNET" />
  ```

#### Privacy

This SDK collects a user’s [App-Set ID](https://developer.android.com/training/articles/app-set-id) for Fraud Prevention purposes. When publishing to the Play Store, disclose the usage of Device Identifiers as follows:

- Data Types: Device or other IDs
- Collected: Yes
- Shared: No
- Processed Ephemerally: No
- Required or Optional: Required
- Purposes: Fraud Prevention

#### Theming

Using the `styles.xml` of your app, you can set colors, buttons and more to customize the Persona flow to your own style. Just extend the base Persona style `Base.Persona.Inquiry.Theme` and name it `Persona.Inquiry.Theme`.

```xml
<style name="Persona.Inquiry.Theme" parent="@style/Base.Persona.Inquiry.Theme">
    <item name="colorPrimary">#22CB8E</item>
    <item name="colorAccent">#22CB8E</item>
    <item name="colorPrimaryDark">#167755</item>
</style>
```

and in your `InquiryConfiguration` set the theme:

```dart
...
theme: InquiryTheme(source: InquiryThemeSource.client)
...
```

_**Important:** Client side theming is **deprecated**. Themes can be managed in the Dashboard with Persona's visual editor. See the detailed [tutorial](https://help.withpersona.com/articles/6SIHupp847yaEuVMucKAff/tutorial-configure-a-theme-with-flow-editor/) for more information._

## Usage

### Starting an Inquiry

To start a Persona inquiry flow, first initialize it with a configuration, then call start:

```dart
// Initialize the inquiry
await PersonaInquiry.init(configuration: yourConfiguration);

// Start the inquiry flow
await PersonaInquiry.start();
```

### Disposing an Inquiry

If you need to programmatically close the inquiry flow and clean up resources, use the `dispose()` method:

```dart
await PersonaInquiry.dispose();
```

This is useful when:

- You need to cancel an ongoing inquiry from your app's logic
- You want to clean up resources before starting a new inquiry
- Your app needs to navigate away while an inquiry is in progress

**Note:** On iOS, calling `dispose()` will dismiss the inquiry UI if it's currently presented. On Android, it will clear the inquiry reference.

### Listening to Events

Subscribe to inquiry events to handle completion, cancellation, and errors:

```dart
// Listen for successful completion
PersonaInquiry.onComplete.listen((InquiryComplete event) {
  print('Inquiry completed: ${event.inquiryId}');
  print('Status: ${event.status}');
  print('Fields: ${event.fields}');
});

// Listen for cancellation
PersonaInquiry.onCanceled.listen((InquiryCanceled event) {
  print('Inquiry canceled: ${event.inquiryId}');
});

// Listen for errors
PersonaInquiry.onError.listen((InquiryError event) {
  print('Inquiry error: ${event.error}');
});
```

Remember to cancel your stream subscriptions when disposing your widget:

```dart
@override
void dispose() {
  _streamComplete.cancel();
  _streamCanceled.cancel();
  _streamError.cancel();
  super.dispose();
}
```
