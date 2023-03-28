/// Base class for inquiry events
abstract class InquiryEvent {}

/// Inquiry complete event
class InquiryComplete extends InquiryEvent {
  /// A unique Persona-generated identifier for the inquiry. If a user cancels before an inquiry has been created this will be nil.
  String? inquiryId;

  /// Result from the Inquiry flow
  String status;

  /// Fields data extracted from the Inquiry flow
  Map<String, dynamic> fields;

  InquiryComplete({
    this.inquiryId,
    required this.status,
    required this.fields,
  });

  factory InquiryComplete.fromJson(dynamic json) {
    return InquiryComplete(
      inquiryId: json["inquiryId"],
      status: json["status"],
      fields: (json.arguments['fields'] as Map).map((key, value) => MapEntry<String, dynamic>(key.toString(), value)),
    );
  }
}

/// Inquiry canceled event
class InquiryCanceled extends InquiryEvent {
  /// A unique Persona-generated identifier for the inquiry. If a user cancels before an inquiry has been created this will be nil.
  String? inquiryId;

  /// The session token used for this inquiry
  String? sessionToken;

  InquiryCanceled({
    this.inquiryId,
    this.sessionToken,
  });

  factory InquiryCanceled.fromJson(dynamic json) {
    return InquiryCanceled(
      inquiryId: json["inquiryId"],
      sessionToken: json["sessionToken"],
    );
  }
}

/// Inquiry error event
class InquiryError extends InquiryEvent {
  /// The reason why the Inquiry did not complete correctly
  String? error;

  InquiryError({
    this.error,
  });

  factory InquiryError.fromJson(dynamic json) {
    return InquiryError(
      error: json["error"],
    );
  }
}
