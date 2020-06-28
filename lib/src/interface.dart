/// Consolidated information collected in the inquiry about the individual
class InquiryAttributes {
  /// The name for the individual
  ///
  /// The first name
  final String firstName;

  /// The middle name
  final String middleName;

  /// The last name
  final String lastName;

  /// The address for the individual
  ///
  /// The street name
  final String street1;

  /// An optional additioal street field
  final String street2;

  /// The city
  final String city;

  /// The subdivision, e.g. state or province
  final String subdivision;

  /// The postal code or zip code
  final String postalCode;

  /// The country code
  final String countryCode;

  /// The birthdate of the individual
  final DateTime birthdate;

  InquiryAttributes(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.street1,
      this.street2,
      this.city,
      this.subdivision,
      this.postalCode,
      this.countryCode,
      this.birthdate});
}

/// Validating the personal information submitted by an individual
///
/// More info: https://docs.withpersona.com/docs/verification-types
class InquiryVerification {
  /// Identifier for the Verification.
  final String id;

  /// Status indicating whether the verification passed, requires retry, or failed.
  final String status;

  InquiryVerification({
    this.id,
    this.status,
  });
}

/// Individual components that are collected through the Inquiry
class InquiryRelationships {
  /// List of verifications
  final List<InquiryVerification> verifications;

  InquiryRelationships({this.verifications});
}
