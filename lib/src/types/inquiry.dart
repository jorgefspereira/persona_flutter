import '../platform/persona_platform_interface.dart';
import 'configurations.dart';
import 'typedefs.dart';

class PersonaInquiry {
  static PersonaPlatformInterface get _platform => PersonaPlatformInterface.instance;

  /// Called on a successful inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [attributes] consolidated information collected in the inquiry about the individual
  /// - [relationships] individual components that are collected through the Inquiry
  static void onSuccess(InquirySuccessCallback listener) => _platform.onSuccess = listener;

  /// Called when the individual cancels the inquiry.
  static void onCancelled(InquiryCancelledCallback listener) => _platform.onCancelled = listener;

  /// Called when the invidual fails the inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [attributes] consolidated information collected in the inquiry about the individual
  /// - [relationships] individual components that are collected through the Inquiry
  static void onFailed(InquiryFailedCallback listener) => _platform.onFailed = listener;

  /// Called when there is a problem during the Inquiry flow.
  /// - [error] the reason why the Inquiry did not complete correctly
  static void onError(InquiryErrorCallback listener) => _platform.onError = listener;

  /// This starts the Inquiry flow and takes control of the user interface.
  /// Once the flow completes, the control of the user interface is returned to the app and the appropriate callbacks are called.
  static Future<void> start({required InquiryConfiguration configuration}) async {
    return _platform.start(configuration: configuration);
  }
}
