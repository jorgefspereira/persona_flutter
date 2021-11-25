import '../types/enums.dart';
import 'theme.dart';

/// Base classe to all inquiry configurations
abstract class InquiryConfiguration {
  InquiryConfiguration({
    this.iOSTheme,
  });

  /// Theme to use for iOS.
  final InquiryTheme? iOSTheme;

  Map<String, dynamic> toJson();
}

/// Base classe to template configuration objects
class _BaseTemplateConfiguration extends InquiryConfiguration {
  _BaseTemplateConfiguration({
    this.accountId,
    this.referenceId,
    required this.environment,
    required this.fields,
    InquiryTheme? iOSTheme,
  }) : super(iOSTheme: iOSTheme);

  /// The account to associate this inquiry with. The account can be used to monitor user progress in newly created inquiries.
  final String? accountId;

  /// The identifier can be used to monitor user progress in newly created inquiries.
  final String? referenceId;

  /// The environment on which to create inquiries.
  final InquiryEnvironment environment;

  /// Any existing user data you want to attach to the inquiry.
  final Map<String, dynamic> fields;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

/// Configuration object used for creating an inquiry using a template version
class TemplateVersionConfiguration extends _BaseTemplateConfiguration {
  TemplateVersionConfiguration({
    required this.templateVersion,
    String? accountId,
    String? referenceId,
    InquiryEnvironment environment = InquiryEnvironment.sandbox,
    Map<String, dynamic> fields = const {},
    InquiryTheme? iOSTheme,
  }) : super(accountId: accountId, referenceId: referenceId, environment: environment, fields: fields, iOSTheme: iOSTheme);

  /// An existing template version that determines how the flow is customized.
  final String templateVersion;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateVersion': templateVersion,
      'accountId': accountId,
      'referenceId': referenceId,
      'environment': environment.toString().split('.').last,
      'fields': fields,
      'theme': iOSTheme?.toJson(),
    };
  }
}

/// Configuration object used for creating an inquiry using a template version
class TemplateIdConfiguration extends _BaseTemplateConfiguration {
  TemplateIdConfiguration({
    required this.templateId,
    String? accountId,
    String? referenceId,
    InquiryEnvironment environment = InquiryEnvironment.sandbox,
    Map<String, dynamic> fields = const {},
    InquiryTheme? iOSTheme,
  }) : super(accountId: accountId, referenceId: referenceId, environment: environment, fields: fields, iOSTheme: iOSTheme);

  /// An existing template id that determines how the flow is customized.
  final String templateId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateId': templateId,
      'accountId': accountId,
      'referenceId': referenceId,
      'environment': environment.toString().split('.').last,
      'fields': fields,
      'theme': iOSTheme?.toJson(),
    };
  }
}

/// Configuration object used for creating an Inquiry using an inquiry ID.
class InquiryIdConfiguration extends InquiryConfiguration {
  InquiryIdConfiguration({
    required this.inquiryId,
    this.sessionToken,
    InquiryTheme? iOSTheme,
  }) : super(iOSTheme: iOSTheme);

  /// An existing inquiry.
  final String inquiryId;

  /// Session token for resuming an Inquiry. The token must be generated on the server.
  final String? sessionToken;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'inquiryId': inquiryId,
      'sessionToken': sessionToken,
      'theme': iOSTheme?.toJson(),
    };
  }
}
