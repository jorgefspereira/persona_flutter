import 'package:flutter/services.dart';
import 'configurations.dart';
import 'types.dart';
import 'attributes.dart';
import 'relationships.dart';

class Inquiry {
  /// Create a Inquiry object.
  ///
  /// The Persona Inquiry verification flow is initiated with an configuration which
  /// can be initialized with either a templateId or an inquiryId.
  Inquiry({
    required this.configuration,
    this.onSuccess,
    this.onCancelled,
    this.onFailed,
    this.onError,
  }) : _channel = MethodChannel('persona_flutter') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  /// The Inquiry configuration.
  final InquiryConfiguration configuration;

  /// The [MethodChannel] over which this class communicates.
  final MethodChannel _channel;

  /// Called on a successful inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [attributes] consolidated information collected in the inquiry about the individual
  /// - [relationships] individual components that are collected through the Inquiry
  final SuccessCallback? onSuccess;

  /// Called when the individual cancels the inquiry.
  final CancelledCallback? onCancelled;

  /// Called when the invidual fails the inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [attributes] consolidated information collected in the inquiry about the individual
  /// - [relationships] individual components that are collected through the Inquiry
  final FailedCallback? onFailed;

  /// Called when there is a problem during the Inquiry flow.
  /// - [error] the reason why the Inquiry did not complete correctly
  final ErrorCallback? onError;

  /// Handles receiving messages on the [MethodChannel]
  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        InquiryAttributes attributes =
            InquiryAttributes.fromJson(call.arguments['attributes']);
        InquiryRelationships relationships =
            InquiryRelationships.fromJson(call.arguments['relationships']);
        onSuccess?.call(
            call.arguments['inquiryId'] as String, attributes, relationships);
        break;

      case 'onCancelled':
        onCancelled?.call();
        break;

      case 'onFailed':
        InquiryAttributes attributes =
            InquiryAttributes.fromJson(call.arguments['attributes']);
        InquiryRelationships relationships =
            InquiryRelationships.fromJson(call.arguments['relationships']);
        onFailed?.call(
            call.arguments['inquiryId'] as String, attributes, relationships);
        break;

      case 'onError':
        onError?.call(call.arguments['error'] as String);
        break;

      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }

  /// This starts the Inquiry flow and takes control of the user interface.
  /// Once the flow completes, the control of the user interface is returned to the app and the appropriate callbacks are called.
  void start() {
    _channel.invokeMethod('start', configuration.toJson());
  }
}
