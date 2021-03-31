import 'package:persona_flutter/persona_flutter.dart';

/// Validating the personal information submitted by an individual
///
/// More info: https://docs.withpersona.com/docs/verification-types
class InquiryVerification {
  /// Identifier for the Verification.
  final String id;

  /// Status indicating whether the verification passed, requires retry, or failed.
  final InquiryVerificationStatus status;

  /// The type of the verification
  final InquiryVerificationType type;

  InquiryVerification({
    this.id,
    this.status,
    this.type,
  });

  factory InquiryVerification.fromJson(dynamic json) {
    InquiryVerificationType type;
    InquiryVerificationStatus status;

    InquiryVerificationStatus.values.forEach((item) {
      if (item.toString().split('.').last == json["status"]) {
        status = item;
      }
    });

    InquiryVerificationType.values.forEach((item) {
      if (item.toString().split('.').last == json["type"]) {
        type = item;
      }
    });

    return InquiryVerification(
        id: json["id"] as String, status: status, type: type);
  }
}
