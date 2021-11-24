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
    required this.id,
    required this.status,
    required this.type,
  });

  factory InquiryVerification.fromJson(dynamic json) {
    InquiryVerificationStatus status =
        InquiryVerificationStatus.values.firstWhere(
      (item) => item.toString().split('.').last == json["status"],
      orElse: () => InquiryVerificationStatus.unknown,
    );

    InquiryVerificationType type = InquiryVerificationType.values.firstWhere(
      (item) => item.toString().split('.').last == json["type"],
      orElse: () => InquiryVerificationType.unknown,
    );

    return InquiryVerification(
        id: json["id"] as String, status: status, type: type);
  }
}
