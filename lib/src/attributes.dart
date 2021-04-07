/// Consolidated information collected in the inquiry about the individual
class InquiryAttributes {
  /// The name of the individual
  final InquiryName? name;

  /// The address of the individual
  final InquiryAddress? address;

  /// The birthdate of the individual
  final DateTime? birthdate;

  InquiryAttributes({
    this.name,
    this.address,
    this.birthdate,
  });

  factory InquiryAttributes.fromJson(dynamic json) {
    return InquiryAttributes(
      name: InquiryName.fromJson(json["name"]),
      address: InquiryAddress.fromJson(json["address"]),
      birthdate: DateTime.parse(json["birthdate"] as String),
    );
  }
}

/// The name object for the individual
class InquiryName {
  /// The first name
  final String? first;

  /// The middle name
  final String? middle;

  /// The last name
  final String? last;

  InquiryName({this.first, this.middle, this.last});

  factory InquiryName.fromJson(dynamic json) {
    return InquiryName(
      first: json["first"] as String?,
      middle: json["middle"] as String?,
      last: json["last"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'first': first,
      'middle': middle,
      'last': last,
    };
  }
}

/// The address for the individual
class InquiryAddress {
  /// The street name
  final String? street1;

  /// An optional additioal street field
  final String? street2;

  /// The city
  final String? city;

  /// The subdivision, e.g. state or province
  final String? subdivision;

  /// The subdivision abbreviated, e.g. “CA” or “PR”
  final String? subdivisionAbbr;

  /// The postal code or zip code
  final String? postalCode;

  /// The country code
  final String? countryCode;

  InquiryAddress({
    this.street1,
    this.street2,
    this.city,
    this.subdivision,
    this.subdivisionAbbr,
    this.postalCode,
    this.countryCode,
  });

  factory InquiryAddress.fromJson(dynamic json) {
    return InquiryAddress(
      street1: json["street1"] as String?,
      street2: json["street2"] as String?,
      city: json["city"] as String?,
      subdivision: json["subdivision"] as String?,
      subdivisionAbbr: json["subdivisionAbbr"] as String?,
      postalCode: json["postalCode"] as String?,
      countryCode: json["countryCode"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'street1': street1,
      'street2': street2,
      'city': city,
      'subdivision': subdivision,
      'subdivisionAbbr': subdivisionAbbr,
      'postalCode': postalCode,
      'countryCode': countryCode,
    };
  }
}
