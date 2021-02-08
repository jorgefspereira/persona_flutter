import 'package:flutter/services.dart';
import 'package:persona_flutter/src/fields.dart';
import 'enums.dart';
import 'attributes.dart';
import 'relationships.dart';

/// A function-type description for onSuccess callback
typedef void SuccessCallback(
  String inquiryId,
  InquiryAttributes attributes,
  InquiryRelationships relationships,
);

/// A function-type description for onFailed callback
typedef void FailedCallback(
  String inquiryId,
  InquiryAttributes attributes,
  InquiryRelationships relationships,
);

/// A function-type description for onCancelled callback
typedef void CancelledCallback();

/// A function-type description for onError callback
typedef void ErrorCallback(String error);

class Inquiry {
  /// Create a Inquiry object.
  ///
  /// The Persona Inquiry verification flow is initiated with an configuration which
  /// can be initialized with either a templateId or an inquiryId.
  Inquiry({
    this.inquiryId,
    this.accessToken,
    this.templateId,
    this.referenceId,
    this.accountId,
    this.environment,
    this.fields,
    this.note,
    this.onSuccess,
    this.onCancelled,
    this.onFailed,
    this.onError,
  })  : _channel = MethodChannel('persona_flutter'),
        assert(templateId != null || inquiryId != null) {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  /// An existing inquiry.
  final String inquiryId;

  /// accessToken
  final String accessToken;

  /// An existing template that determines how the flow is customized.
  final String templateId;

  /// The account to associate this inquiry with. The account can be used to monitor user progress in newly created inquiries.
  final String accountId;

  /// The identifier can be used to monitor user progress in newly created inquiries.
  final String referenceId;

  /// Any existing user data you want to attach to the inquiry.
  final InquiryFields fields;

  /// Any string you want for your own bookkeeping.
  final String note;

  /// The environment on which to create inquiries.
  final InquiryEnvironment environment;

  /// The [MethodChannel] over which this class communicates.
  final MethodChannel _channel;

  /// Called on a successful inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [attributes] consolidated information collected in the inquiry about the individual
  /// - [relationships] individual components that are collected through the Inquiry
  final SuccessCallback onSuccess;

  /// Called when the individual cancels the inquiry.
  final CancelledCallback onCancelled;

  /// Called when the invidual fails the inquiry.
  /// - [inquiryId] a unique Persona-generated identifier for the inquiry
  /// - [attributes] consolidated information collected in the inquiry about the individual
  /// - [relationships] individual components that are collected through the Inquiry
  final FailedCallback onFailed;

  /// Called when there is a problem during the Inquiry flow.
  /// - [error] the reason why the Inquiry did not complete correctly
  final ErrorCallback onError;

  /// Handles receiving messages on the [MethodChannel]
  Future<bool> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        if (this.onSuccess != null) {
          InquiryAttributes attributes =
              InquiryAttributes.fromJson(call.arguments['attributes']);
          InquiryRelationships relationships =
              InquiryRelationships.fromJson(call.arguments['relationships']);

          this.onSuccess(
              call.arguments['inquiryId'], attributes, relationships);
        }
        return null;

      case 'onCancelled':
        if (this.onCancelled != null) {
          this.onCancelled();
        }
        return null;

      case 'onFailed':
        if (this.onFailed != null) {
          InquiryAttributes attributes =
              InquiryAttributes.fromJson(call.arguments['attributes']);
          InquiryRelationships relationships =
              InquiryRelationships.fromJson(call.arguments['relationships']);

          this.onFailed(call.arguments['inquiryId'], attributes, relationships);
        }
        return null;

      case 'onError':
        if (this.onError != null) {
          this.onError(call.arguments['error']);
        }
        return null;
    }
    throw MissingPluginException(
        '${call.method} was invoked but has no handler');
  }

  /// This starts the Inquiry flow and takes control of the user interface.
  /// Once the flow completes, the control of the user interface is returned to the app and the appropriate callbacks are called.
  void start() {
    _channel.invokeMethod(
      'start',
      <String, dynamic>{
        'templateId': templateId,
        'accesstoken': accessToken,
        'inquiryId': inquiryId,
        'accountId': accountId,
        'referenceId': referenceId,
        'environment':
            environment != null ? environment.toString().split('.').last : null,
        'fields': fields?.toJson(),
        'note': note,
      },
    );
  }
}
