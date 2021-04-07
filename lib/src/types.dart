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

/// The Persona API environment on which to create inquiries.
enum InquiryEnvironment {
  /// The development environment.
  sandbox,

  /// The production environment.
  production
}

/// The status for a verification.
enum InquiryVerificationStatus {
  /// Persona verified the individual’s information.
  passed,

  /// Persona could not verify the individual’s information, because it was incomplete.
  requiresRetry,

  /// Persona has enough information to determine that the individual should not be verified.
  failed,

  /// If a conversion error occur an unknown type is returned.
  unknown
}

/// The type for a verification
enum InquiryVerificationType {
  /// If the individual is asked to provide a personal details in the inquiry flow,
  /// Persona will check them against public and private databases to confirm that
  /// the information provided is valid.
  database,

  /// When the individual is asked to submit a document as a proof of employment or proof
  /// of address, Persona will inspect the document for authenticity and extract the relevant
  /// information from it for additional consumption.
  document,

  /// If the individual is asked to submit a government ID such as a driver license,
  /// national ID, or passport, Persona will inspect the ID for authenticity and extract
  /// the relevant information from it for additional consumption.
  governmentId,

  /// If the individual is asked to provide a phone number in the inquiry flow, Persona will
  /// send a confirmation PIN code to that phone number and then check the number against public
  /// and private databases to confirm that the information provided is valid.
  phoneNumber,

  /// When the individual takes a video of their face in real-time, Persona will check that the
  /// individual is live and real. If the individual also submits a government ID, the face captured
  /// in the selfie is compared against the face in the government ID.
  selfie,

  /// If a conversion error occur an unknown type is returned.
  unknown
}
