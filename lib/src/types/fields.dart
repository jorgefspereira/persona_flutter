import 'package:intl/intl.dart';

import 'attributes.dart';

/// A collection of information about the individual from the inquiry
class InquiryFields {
  /// The name of the individual
  final InquiryName? name;

  /// The address of the individual
  final InquiryAddress? address;

  /// The birthdate of the individual
  final DateTime? birthdate;

  /// The phone number of the individual
  final String? phoneNumber;

  /// The email address of the individual
  final String? emailAddress;

  /// Any additional data of the individual
  final Map<String, dynamic>? additionalFields;

  InquiryFields({
    this.name,
    this.address,
    this.birthdate,
    this.phoneNumber,
    this.emailAddress,
    this.additionalFields,
  });

  factory InquiryFields.fromJson(dynamic json) {
    return InquiryFields(
      name: InquiryName.fromJson(json["name"]),
      address: InquiryAddress.fromJson(json["address"]),
      birthdate: DateTime.parse(json["birthdate"] as String),
      phoneNumber: json["phoneNumber"] as String?,
      emailAddress: json["emailAddress"] as String?,
      additionalFields: json["additionalFields"] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');

    return <String, dynamic>{
      'name': name?.toJson(),
      'address': address?.toJson(),
      'birthdate': birthdate != null ? formatter.format(birthdate!) : null,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'additionalFields': additionalFields,
    };
  }
}
