import 'verifications.dart';

/// Individual components that are collected through the Inquiry
class InquiryRelationships {
  /// List of verifications
  final List<InquiryVerification> verifications;

  InquiryRelationships({required this.verifications});

  factory InquiryRelationships.fromJson(dynamic json) {
    List<InquiryVerification> verifications = [];

    for (var item in json) {
      verifications.add(InquiryVerification.fromJson(item));
    }

    return InquiryRelationships(verifications: verifications);
  }
}
