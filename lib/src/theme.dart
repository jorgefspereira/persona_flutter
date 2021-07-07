import 'dart:ui';

/// Elements used to theme the Persona screens with custom colors, fonts,
/// text sizes, and corner radius.
class InquiryTheme {
  InquiryTheme({
    this.buttonShadowColor,
    this.buttonShadowRadius,
    this.buttonShadowAlpha,
    this.buttonShadowWidth,
    this.buttonShadowHeight,
    this.cancelButtonShadowRadius,
    this.errorColor,
    this.overlayBackgroundColor,
    this.textFieldBackgroundColor,
    this.buttonDisabledTextColor,
    this.checkboxBackgroundColor,
    this.checkboxForegroundColor,
    this.cancelButtonTextColor,
    this.cancelButtonAlternateBackgroundColor,
    this.cancelButtonAlternateTextColor,
    this.cancelButtonShadowColor,
    this.separatorColor,
    this.backgroundColor,
    this.textFieldBorderColor,
    this.buttonBackgroundColor,
    this.buttonTouchedBackgroundColor,
    this.buttonDisabledBackgroundColor,
    this.closeButtonTintColor,
    this.cancelButtonBackgroundColor,
    this.selectedCellBackgroundColor,
    this.accentColor,
    this.darkPrimaryColor,
    this.primaryColor,
    this.titleTextColor,
    this.bodyTextColor,
    this.formLabelTextColor,
    this.buttonTextColor,
    this.pickerTextColor,
    this.textFieldTextColor,
    this.footnoteTextColor,
    this.buttonCornerRadius,
    this.textFieldCornerRadius,
    this.titleFontFamily,
    this.titleFontSize,
    this.bodyFontFamily,
    this.bodyFontSize,
    this.buttonFontFamily,
    this.buttonFontSize,
    this.showGovernmentIdIcons,
    this.errorFontFamily,
    this.errorFontSize,
    this.navigationBarTextColor,
    this.navigationBarTextFontFamily,
    this.navigationBarTextFontSize,
    this.textFieldFontFamily,
    this.textFieldFontSize,
    this.textFieldPlaceholderFontFamily,
    this.textFieldPlaceholderFontSize,
    this.pickerFontFamily,
    this.pickerFontSize,
    this.cameraInstructionsTextColor,
    this.cameraButtonAlternateBackgroundColor,
    this.cameraButtonAlternateTextColor,
    this.cameraButtonBackgroundColor,
    this.cameraButtonTextColor,
    this.cameraGuideCornersColor,
    this.cameraGuideHintTextColor,
    this.cameraHintTextColor,
  });

  /// The background color for all views.
  final Color? backgroundColor;

  /// The primary color.
  final Color? primaryColor;

  /// The darker, primary color.
  final Color? darkPrimaryColor;

  /// The accent color.
  final Color? accentColor;

  /// The error color.
  final Color? errorColor;

  /// Error font family
  final String? errorFontFamily;

  /// Error font size (pt)
  final double? errorFontSize;

  /// The background color for overlay views.
  final Color? overlayBackgroundColor;

  /// The text color for title labels.
  final Color? navigationBarTextColor;

  /// Navigation bar font family
  final String? navigationBarTextFontFamily;

  /// Navigation bar font size
  final double? navigationBarTextFontSize;

  /// The text color for title labels.
  final Color? titleTextColor;

  /// Title font family
  final String? titleFontFamily;

  /// Title font size (pt)
  final double? titleFontSize;

  /// The text color for body labels.
  final Color? bodyTextColor;

  /// Body font family
  final String? bodyFontFamily;

  /// Body font size (pt)
  final double? bodyFontSize;

  /// The text color for footnote labels.
  final Color? footnoteTextColor;

  /// The text color for form labels.
  final Color? formLabelTextColor;

  /// The text color for text fields.
  final Color? textFieldTextColor;

  /// The background color for text fields.
  final Color? textFieldBackgroundColor;

  /// The border color for text fields.
  final Color? textFieldBorderColor;

  /// The corner radius for text fields.
  final double? textFieldCornerRadius;

  /// Text fields font family
  final String? textFieldFontFamily;

  /// Text fields font size
  final double? textFieldFontSize;

  /// Placeholder text font family
  final String? textFieldPlaceholderFontFamily;

  /// Placeholder text font size
  final double? textFieldPlaceholderFontSize;

  /// Picker font family
  final String? pickerFontFamily;

  /// Picker font size
  final double? pickerFontSize;

  /// The text color for picker items.
  final Color? pickerTextColor;

  /// The background color for buttons, in the normal state.
  final Color? buttonBackgroundColor;

  /// The background color for buttons, in the disabled state.
  final Color? buttonDisabledBackgroundColor;

  /// The background color for buttons, in the touched state.
  final Color? buttonTouchedBackgroundColor;

  /// The text color for button text, in the normal state.
  final Color? buttonTextColor;

  /// The text color for button text, in the disabled state.
  final Color? buttonDisabledTextColor;

  /// The corner radius to apply to buttons.
  final double? buttonCornerRadius;

  /// Button font family
  final String? buttonFontFamily;

  /// Button font size (pt)
  final double? buttonFontSize;

  /// The shadow color for buttons (this should include the desired opacity)
  final Color? buttonShadowColor;

  /// The alpha value (0..1) used to render the shadow.
  final double? buttonShadowAlpha;

  /// The blur width used to render the shadow..
  final double? buttonShadowWidth;

  /// The blur height used to render the shadow..
  final double? buttonShadowHeight;

  /// The blur radius (in points) used to render the shadow.
  final double? buttonShadowRadius;

  /// The background color for checkboxes, in the normal state.
  final Color? checkboxBackgroundColor;

  /// The foreground color for checkboxes, in the normal state.
  final Color? checkboxForegroundColor;

  /// The text color for a selected table view cell.
  final Color? selectedCellBackgroundColor;

  /// The tint to apply to the close button.
  final Color? closeButtonTintColor;

  /// The background color for buttons when cancelling a verification.
  final Color? cancelButtonBackgroundColor;

  /// The text color for buttons when cancelling a verification.
  final Color? cancelButtonTextColor;

  /// The background color for the “Yes, cancel” button when cancelling a verification.
  final Color? cancelButtonAlternateBackgroundColor;

  /// The text color for the “Yes, cancel” button when cancelling a verification.
  final Color? cancelButtonAlternateTextColor;

  /// The shadow color for buttons (this should include the desired opacity)
  final Color? cancelButtonShadowColor;

  /// The blur radius (in points) used to render the shadow.
  final double? cancelButtonShadowRadius;

  /// The border color for separators.
  final Color? separatorColor;

  /// Whether or not to show the icons next to government ID types
  final bool? showGovernmentIdIcons;

  /// The text color for camera hint titles.
  final Color? cameraInstructionsTextColor;

  /// The background color for the button that takes a photo.
  final Color? cameraButtonBackgroundColor;

  /// The text color for the button that takes a photo.
  final Color? cameraButtonTextColor;

  /// The background color for the button that re-takes a photo.
  final Color? cameraButtonAlternateBackgroundColor;

  /// The text color for the button that re-takes a photo.
  final Color? cameraButtonAlternateTextColor;

  /// The text color for camera hint titles.
  final Color? cameraHintTextColor;

  /// The text color for camera guide hint titles.
  final Color? cameraGuideHintTextColor;

  /// The text color for the [ ] corners shown as a guide when the user is taking a photo.
  final Color? cameraGuideCornersColor;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'backgroundColor': _toHex(backgroundColor),
      'textFieldBorderColor': _toHex(textFieldBorderColor),
      'buttonBackgroundColor': _toHex(buttonBackgroundColor),
      'buttonTouchedBackgroundColor': _toHex(buttonTouchedBackgroundColor),
      'buttonDisabledBackgroundColor': _toHex(buttonDisabledBackgroundColor),
      'closeButtonTintColor': _toHex(closeButtonTintColor),
      'cancelButtonBackgroundColor': _toHex(cancelButtonBackgroundColor),
      'selectedCellBackgroundColor': _toHex(selectedCellBackgroundColor),
      'accentColor': _toHex(accentColor),
      'darkPrimaryColor': _toHex(darkPrimaryColor),
      'primaryColor': _toHex(primaryColor),
      'titleTextColor': _toHex(titleTextColor),
      'bodyTextColor': _toHex(bodyTextColor),
      'formLabelTextColor': _toHex(formLabelTextColor),
      'buttonTextColor': _toHex(buttonTextColor),
      'pickerTextColor': _toHex(pickerTextColor),
      'textFieldTextColor': _toHex(textFieldTextColor),
      'footnoteTextColor': _toHex(footnoteTextColor),
      'buttonCornerRadius': buttonCornerRadius,
      'textFieldCornerRadius': textFieldCornerRadius,
      'errorColor': _toHex(errorColor),
      'overlayBackgroundColor': _toHex(overlayBackgroundColor),
      'textFieldBackgroundColor': _toHex(textFieldBackgroundColor),
      'buttonDisabledTextColor': _toHex(buttonDisabledTextColor),
      'checkboxBackgroundColor': _toHex(checkboxBackgroundColor),
      'checkboxForegroundColor': _toHex(checkboxForegroundColor),
      'cancelButtonTextColor': _toHex(cancelButtonTextColor),
      'cancelButtonShadowColor': _toHex(cancelButtonShadowColor),
      'separatorColor': _toHex(separatorColor),
      'buttonShadowColor': _toHex(buttonShadowColor),
      'buttonShadowAlpha': buttonShadowAlpha,
      'buttonShadowRadius': buttonShadowRadius,
      'buttonShadowWidth': buttonShadowWidth,
      'buttonShadowHeight': buttonShadowHeight,
      'cancelButtonShadowRadius': cancelButtonShadowRadius,
      'titleFontFamily': titleFontFamily,
      'titleFontSize': titleFontSize,
      'bodyFontFamily': bodyFontFamily,
      'bodyFontSize': bodyFontSize,
      'buttonFontFamily': buttonFontFamily,
      'buttonFontSize': buttonFontSize,
      'showGovernmentIdIcons': showGovernmentIdIcons,
      'errorFontSize': errorFontSize,
      'errorFontFamily': errorFontFamily,
      'navigationBarTextColor': _toHex(navigationBarTextColor),
      'navigationBarTextFontSize': navigationBarTextFontSize,
      'navigationBarTextFontFamily': navigationBarTextFontFamily,
      'textFieldPlaceholderFontSize': textFieldPlaceholderFontSize,
      'textFieldPlaceholderFontFamily': textFieldPlaceholderFontFamily,
      'textFieldFontSize': textFieldFontSize,
      'textFieldFontFamily': textFieldFontFamily,
      'pickerFontSize': pickerFontSize,
      'pickerFontFamily': pickerFontFamily,
      'cameraHintTextColor': _toHex(cameraHintTextColor),
      'cameraInstructionsTextColor': _toHex(cameraInstructionsTextColor),
      'cameraGuideCornersColor': _toHex(cameraGuideCornersColor),
      'cameraGuideHintTextColor': _toHex(cameraGuideHintTextColor),
      'cameraButtonTextColor': _toHex(cameraButtonTextColor),
      'cameraButtonBackgroundColor': _toHex(cameraButtonBackgroundColor),
      'cameraButtonAlternateTextColor': _toHex(cameraButtonAlternateTextColor),
      'cameraButtonAlternateBackgroundColor':
          _toHex(cameraButtonAlternateBackgroundColor),
      'cancelButtonAlternateTextColor': _toHex(cancelButtonAlternateTextColor),
      'cancelButtonAlternateBackgroundColor':
          _toHex(cancelButtonAlternateBackgroundColor),
    };
  }

  String? _toHex(Color? color) {
    return color != null ? '#${color.value.toRadixString(16)}' : null;
  }
}
