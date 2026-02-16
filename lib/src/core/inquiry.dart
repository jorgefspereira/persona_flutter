import 'package:persona_flutter/persona_flutter.dart';

import '../platform/persona_platform_interface.dart';

class PersonaInquiry {
  static PersonaPlatformInterface get _platform =>
      PersonaPlatformInterface.instance;

  /// Called on a completed inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [status] result from the Inquiry flow
  /// - [fields] fields data extracted from the Inquiry flow
  static Stream<InquiryComplete> get onComplete =>
      _platform.onEvent.where((event) => event is InquiryComplete).cast();

  /// Called when the individual cancels the inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [sessionToken] the session token used for this inquiry
  static Stream<InquiryCanceled> get onCanceled =>
      _platform.onEvent.where((event) => event is InquiryCanceled).cast();

  /// Called when there is a problem during the Inquiry flow.
  /// - [error] the reason why the Inquiry did not complete correctly
  static Stream<InquiryError> get onError =>
      _platform.onEvent.where((event) => event is InquiryError).cast();

  /// Called when a granular inquiry event occurs (e.g. start, page_change).
  static Stream<InquiryEventOccurred> get onEvent =>
      _platform.onEvent.where((event) => event is InquiryEventOccurred).cast();

  /// Creates a new Inquiry based on a [InquiryConfiguration]
  static Future<void> init(
      {required InquiryConfiguration configuration}) async {
    return _platform.init(configuration: configuration);
  }

  /// This starts the Inquiry flow and takes control of the user interface.
  /// Once the flow completes, the control of the user interface is returned to the app and the appropriate callbacks are called.
  static Future<void> start() async {
    return _platform.start();
  }

  /// Disposes of the current inquiry and cleans up resources.
  /// Call this when you want to programmatically end the inquiry flow.
  static Future<void> dispose() async {
    return _platform.dispose();
  }
}
