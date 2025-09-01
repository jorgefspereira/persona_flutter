## 3.2.10
* Updated Android SDK to 2.21.0
* Updated iOS SDK to 2.29.1

## 3.2.9

* Updated Android SDK to 2.20.0
* Updated iOS SDK to 2.28.1

## 3.2.8

* Fixed iOS SDK version

## 3.2.7

* Added stub Persona.Inquiry.Theme to fix missing R.style issues.
* Updated Android SDK to 2.12.10
* Updated iOS SDK to 2.22.5

## 3.2.6

* Updated Android SDK to 2.12.4
* Updated iOS SDK to 2.22.3
* Fixed issue with isResultSubmitted not allowing automated testing.

## 3.2.5

* Downgraded required dart sdk version
* Gradle compatibility issues

## 3.2.4

* Added locale to support override of the device locale with desired language.

## 3.2.3

* Updated Android SDK to 2.12.2
* Updated iOS SDK to 2.21.2.
* Removed old intl dependency.
* Removed imperative apply of Flutter's Gradle plugins

## 3.2.2

* Updated Android SDK to 2.11.6
* Updated iOS SDK to 2.20.3
* Fixed issue with reply already submitted. (winmalveda)

## 3.2.1

* Updated Android SDK to 2.10.12
* Updated iOS SDK to 2.15.0

## 3.2.0

* Updated Android SDK to 2.10.9
* Updated iOS SDK to 2.13.0
* Changed to Inquiry Builders
* Added EnvironmentId and RoutingCountry parameters

## 3.1.2

* Updated Android SDK to 2.10.6
* Updated Gradle version to 7.4.2 
* Updated iOS SDK to 2.12.6
* Closed issue #31

## 3.1.1

* Flutter 3.10 support
* Dart 3 support
* Changed intl version 0.17.0 to 0.18.0
* Updated iOS SDK to 2.8.0
* Updated Android SDK to 2.6.0

## 3.1.0

* Updated Android SDK to 2.4.0
* Updated Gradle version to 7.2.0
* Updated iOS SDK to 2.7.3
* Implemented and event channel to receive changes from the native platform.
* Changed jcenter to mavenCentral
* Added support for Theme sources

## 3.0.1-beta.0

* Updated Android SDK to 2.2.37
* Updated Gradle version to 7.1.2
* Updated iOS SDK to 2.4.1

## 3.0.0-beta.0

* Initial release of native v2 SDKs implementation

## 2.1.5

* Updated jCenter to mavenCentral

## 2.1.4

* minor fix with intl dependency

## 2.1.3

* Upgraded iOS SDK to 1.1.28
* Upgraded Android SDK to 1.1.24

## 2.1.2

* Upgraded iOS SDK to 1.1.27

## 2.1.1

* Fix typedefs export.
* Fix birthday serialization.
* Upgraded iOS SDK to 1.1.25.
* Upgraded Android SDK to 1.1.19.

## 2.1.0

* BREAKING CHANGE: "Inquiry" class is now "PersonaInquiry" with only static methods (see example provided)
* BREAKING CHANGE: Renamed all callbacks with "Inquiry" prefix (e.g. SuccessCallback -> InquirySuccessCallback)
* BREAKING CHANGE: Renamed the following iOS theme properties: titleFont*, bodyFont*, errorFont*, pickerFont* -> titleTextFont*, bodyTextFont*, errorTextFont*, pickerTextFont*.
* Added new iOS theme properties: footnoteTextFontFamily, footnoteTextFontSize, formLabelTextFontFamily, formLabelTextFontSize
* Integrated plugin_platform_interface dependency.
* Upgraded iOS SDK to 1.1.22.
* Upgraded Android SDK to 1.1.15.

## 2.0.4

* Added new theme properties: cancelButtonAlternateTextColor, cancelButtonAlternateBackgroundColor, cancelButtonTextColor
* Upgraded iOS SDK to 1.1.11.
* Upgraded Android SDK to 1.1.4.

## 2.0.3

* Added new theme properties.
* Upgraded iOS SDK to 1.1.7.
* Upgraded Android SDK to 1.1.3.

## 2.0.2

* Improved iOS theming. Thank you @tomaash.

## 2.0.1

* Upgraded iOS SDK to 1.1.4
 
## 2.0.0

* BREAKING CHANGE: Added InquiryConfiguration to Inquiry object
* Fix typo on InquiryVerificationType 
* Null-safety support
* Added type unknown to InquiryVerificationStatus and InquiryVerificationType

## 1.2.0

* Added InquiryTheme to support ios theming. Thank you @tomaash
* Added support for android theme via styles.xml. Thank you @tomaash
* Upgraded iOS SDK to 1.1.3
* Added additionalFields support on iOS and Android.

## 1.1.0+1

* Fix intl dependency version
* Minor fixes

## 1.1.0

* Upgraded iOS SDK to 1.0.6.
* Upgraded Android SDK to 1.0.11.
* Added support for Fields in Inquiry class.
* Added InquiryVerificationStatus, InquiryVerificationType, InquiryName and InquiryAddress.
* Changed PersonaEnvironment to InquiryEnvironment.

## 1.0.6

* Updated Persona SDK to version 1.0.0

## 1.0.5

* Updated Persona SDK to version 0.12.4

## 1.0.4

* Updated Persona SDK to version 0.11.0

## 1.0.3

* Bug fix: onSuccess and onFailed not being called correctly

## 1.0.2

* Bug fix: environment not passed when inquiry initiated with template id. 

## 1.0.1

* Changed integration guide.

## 1.0.0

* Initial release.