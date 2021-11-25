/// The Persona API environment on which to create inquiries.
enum InquiryEnvironment {
  /// The development environment.
  sandbox,

  /// The production environment.
  production
}

/// A function-type description for onComplete callback
typedef void InquiryCompleteCallback(
  String inquiryId,
  String status,
  Map<String, dynamic> fields,
);

/// A function-type description for onCanceled callback
typedef void InquiryCanceledCallback(
  String? inquiryId,
  String? sessionToken,
);

//// A function-type description for onError callback
typedef void InquiryErrorCallback(String? error);
