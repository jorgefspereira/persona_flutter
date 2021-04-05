import 'dart:ui';

/// Elements used to theme the Persona screens with custom colors, fonts,
/// text sizes, and corner radius.
class InquiryTheme {
  InquiryTheme({
    this.buttonShadowColor,
    this.buttonShadowRadius,
    this.cancelButtonShadowRadius,
    this.errorColor,
    this.overlayBackgroundColor,
    this.textFieldBackgroundColor,
    this.buttonDisabledTextColor,
    this.checkboxBackgroundColor,
    this.checkboxForegroundColor,
    this.cancelButtonTextColor,
    this.cancelButtonShadowColor,
    this.progressColor,
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
  });

  /// The background color for all views.
  final Color backgroundColor;

  /// The primary color.
  final Color primaryColor;

  /// The darker, primary color.
  final Color darkPrimaryColor;

  /// The error color.
  final Color errorColor;

  /// The accent color.
  final Color accentColor;

  /// The background color for overlay views.
  final Color overlayBackgroundColor;

  /// The text color for title labels.
  final Color titleTextColor;

  /// The text color for body labels.
  final Color bodyTextColor;

  /// The text color for footnote labels.
  final Color footnoteTextColor;

  /// The text color for form labels.
  final Color formLabelTextColor;

  /// The text color for text fields.
  final Color textFieldTextColor;

  /// The background color for text fields.
  final Color textFieldBackgroundColor;

  /// The border color for text fields.
  final Color textFieldBorderColor;

  /// The corner radius for text fields.
  final double textFieldCornerRadius;

  /// The text color for picker items.
  final Color pickerTextColor;

  /// The background color for buttons, in the normal state.
  final Color buttonBackgroundColor;

  /// The background color for buttons, in the disabled state.
  final Color buttonDisabledBackgroundColor;

  /// The background color for buttons, in the touched state.
  final Color buttonTouchedBackgroundColor;

  /// The text color for button text, in the normal state.
  final Color buttonTextColor;

  /// The text color for button text, in the disabled state.
  final Color buttonDisabledTextColor;

  /// The corner radius to apply to buttons.
  final double buttonCornerRadius;

  /// The shadow color for buttons (this should include the desired opacity)
  final Color buttonShadowColor;

  /// The blur radius (in points) used to render the shadow.
  final double buttonShadowRadius;

  /// The background color for checkboxes, in the normal state.
  final Color checkboxBackgroundColor;

  /// The foreground color for checkboxes, in the normal state.
  final Color checkboxForegroundColor;

  /// The text color for a selected table view cell.
  final Color selectedCellBackgroundColor;

  /// The tint to apply to the close button.
  final Color closeButtonTintColor;

  /// The background color for buttons when cancelling a verification.
  final Color cancelButtonBackgroundColor;

  /// The text color for buttons when cancelling a verification.
  final Color cancelButtonTextColor;

  /// The shadow color for buttons (this should include the desired opacity)
  final Color cancelButtonShadowColor;

  /// The blur radius (in points) used to render the shadow.
  final double cancelButtonShadowRadius;

  /// The tint to apply to the progress animation items.
  final Color progressColor;

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
      'progressColor': _toHex(progressColor),
      'buttonShadowColor': _toHex(buttonShadowColor),
      'buttonShadowRadius': buttonShadowRadius,
      'cancelButtonShadowRadius': cancelButtonShadowRadius,
    };
  }

  String _toHex(Color color) {
    return color != null ? '#${color.value.toRadixString(16)}' : null;
  }
}
