import 'attributes.dart';
import 'relationships.dart';

/// A function-type description for onSuccess callback
typedef void InquirySuccessCallback(
  String inquiryId,
  InquiryAttributes attributes,
  InquiryRelationships relationships,
);

/// A function-type description for onFailed callback
typedef void InquiryFailedCallback(
  String inquiryId,
  InquiryAttributes attributes,
  InquiryRelationships relationships,
);

/// A function-type description for onCancelled callback
typedef void InquiryCancelledCallback();

/// A function-type description for onError callback
typedef void InquiryErrorCallback(String error);
