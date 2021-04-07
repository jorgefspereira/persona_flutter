import 'types.dart';
import 'fields.dart';
import 'theme.dart';

abstract class InquiryConfiguration {
  InquiryConfiguration({
    this.iOSTheme,
  });

  /// Theme to use for iOS.
  final InquiryTheme? iOSTheme;

  Map<String, dynamic> toJson();
}

class InquiryIdConfiguration extends InquiryConfiguration {
  InquiryIdConfiguration({
    required this.inquiryId,
    this.accessToken,
    InquiryTheme? iOSTheme,
  }) : super(iOSTheme: iOSTheme);

  /// An existing inquiry.
  final String inquiryId;

  /// accessToken
  final String? accessToken;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'inquiryId': inquiryId,
      'accessToken': accessToken,
      'theme': iOSTheme?.toJson(),
    };
  }
}

class TemplateIdConfiguration extends InquiryConfiguration {
  TemplateIdConfiguration({
    required this.templateId,
    this.accountId,
    this.referenceId,
    this.environment,
    this.fields,
    this.note,
    InquiryTheme? iOSTheme,
  }) : super(iOSTheme: iOSTheme);

  /// An existing template that determines how the flow is customized.
  final String templateId;

  /// The account to associate this inquiry with. The account can be used to monitor user progress in newly created inquiries.
  final String? accountId;

  /// The identifier can be used to monitor user progress in newly created inquiries.
  final String? referenceId;

  /// The environment on which to create inquiries.
  final InquiryEnvironment? environment;

  /// Any existing user data you want to attach to the inquiry.
  final InquiryFields? fields;

  /// Any string you want for your own bookkeeping.
  final String? note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateId': templateId,
      'accountId': accountId,
      'referenceId': referenceId,
      'environment':
          environment != null ? environment.toString().split('.').last : null,
      'fields': fields?.toJson(),
      'note': note,
      'theme': iOSTheme?.toJson(),
    };
  }
}
