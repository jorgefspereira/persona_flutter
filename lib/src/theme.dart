import 'dart:ui';

/// Elements used to theme the Persona screens with custom colors, fonts,
/// text sizes, and corner radius.
class InquiryTheme {
  InquiryTheme({
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

  // Colors
  final Color backgroundColor;
  final Color textFieldBorderColor;
  final Color buttonBackgroundColor;
  final Color buttonTouchedBackgroundColor;
  final Color buttonDisabledBackgroundColor;
  final Color closeButtonTintColor;
  final Color cancelButtonBackgroundColor;
  final Color selectedCellBackgroundColor;
  final Color accentColor;
  final Color darkPrimaryColor;
  final Color primaryColor;
  final Color titleTextColor;
  final Color bodyTextColor;
  final Color formLabelTextColor;
  final Color buttonTextColor;
  final Color pickerTextColor;
  final Color textFieldTextColor;
  final Color footnoteTextColor;

  // Corner Radius
  final double buttonCornerRadius;
  final double textFieldCornerRadius;

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
    };
  }

  String _toHex(Color color) {
    return color != null ? '#${color.value.toRadixString(16)}' : null;
  }
}
