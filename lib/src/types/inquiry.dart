import 'package:persona_flutter/persona_flutter.dart';

import '../platform/persona_platform_interface.dart';

class PersonaInquiry {
  static PersonaPlatformInterface get _platform => PersonaPlatformInterface.instance;

  /// Called on a completed inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [status] result from the Inquiry flow
  /// - [fields] fields data extracted from the Inquiry flow
  static void onComplete(InquiryCompleteCallback listener) => _platform.onComplete = listener;

  /// Called when the individual cancels the inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [sessionToken] the session token used for this inquiry
  static void onCanceled(InquiryCanceledCallback listener) => _platform.onCanceled = listener;

  /// Called when there is a problem during the Inquiry flow.
  /// - [error] the reason why the Inquiry did not complete correctly
  static void onError(InquiryErrorCallback listener) => _platform.onError = listener;

  /// Creates a new Inquiry based on a [InquiryConfiguration]
  static Future<void> init({required InquiryConfiguration configuration}) async {
    return _platform.init(configuration: configuration);
  }

  /// This starts the Inquiry flow and takes control of the user interface.
  /// Once the flow completes, the control of the user interface is returned to the app and the appropriate callbacks are called.
  static Future<void> start() async {
    return _platform.start();
  }
}