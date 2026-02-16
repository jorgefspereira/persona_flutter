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

  /// Collected data from the Inquiry flow
  Map<String, dynamic>? collectedData;

  InquiryComplete({
    this.inquiryId,
    required this.status,
    required this.fields,
    this.collectedData,
  });

  factory InquiryComplete.fromJson(dynamic json) {
    return InquiryComplete(
      inquiryId: json["inquiryId"],
      status: json["status"],
      fields: (json['fields'] as Map).map(
          (key, value) => MapEntry<String, dynamic>(key.toString(), value)),
      collectedData: json['collectedData'] != null
          ? Map<String, dynamic>.from(json['collectedData'])
          : null,
    );
  }
}

/// Inquiry event occurred (e.g. start, page_change)
class InquiryEventOccurred extends InquiryEvent {
  /// The type of event (e.g. "start", "page_change")
  final String type;

  /// The inquiry ID (for "start" events)
  final String? inquiryId;

  /// The session token (for "start" events)
  final String? sessionToken;

  /// The name of the page (for "page_change" events)
  final String? name;

  /// The path of the page (for "page_change" events)
  final String? path;

  InquiryEventOccurred({
    required this.type,
    this.inquiryId,
    this.sessionToken,
    this.name,
    this.path,
  });

  factory InquiryEventOccurred.fromJson(dynamic json) {
    if (json['event'] == null) {
      return InquiryEventOccurred(type: 'unknown');
    }
    final eventData = Map<String, dynamic>.from(json['event']);
    return InquiryEventOccurred(
      type: eventData['type'] ?? 'unknown',
      inquiryId: eventData['inquiryId'],
      sessionToken: eventData['sessionToken'],
      name: eventData['name'],
      path: eventData['path'],
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
