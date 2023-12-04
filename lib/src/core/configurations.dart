import '../core/enums.dart';
import 'theme.dart';

/// Base classe to all inquiry configurations
abstract class InquiryConfiguration {
  InquiryConfiguration({
    this.theme,
  });

  /// Inquiry themes control the look and feel of a given flow.
  /// Set theme source to [server] to be configurable in the Persona dashboard.
  final InquiryTheme? theme;

  Map<String, dynamic> toJson();
}

/// Base classe to template configuration objects
class _BaseTemplateConfiguration extends InquiryConfiguration {
  _BaseTemplateConfiguration({
    this.accountId,
    this.referenceId,
    this.environmentId,
    required this.environment,
    required this.fields,
    super.theme,
  });

  /// The account to associate this inquiry with. The account can be used to monitor user progress in newly created inquiries.
  final String? accountId;

  /// The identifier can be used to monitor user progress in newly created inquiries.
  final String? referenceId;
  final String? environmentId;

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
    super.accountId,
    super.referenceId,
    super.environment = InquiryEnvironment.sandbox,
    super.fields = const {},
    super.theme,
  });

  /// An existing template version that determines how the flow is customized.
  final String templateVersion;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateVersion': templateVersion,
      'accountId': accountId,
      'referenceId': referenceId,
      'environment': environment
          .toString()
          .split('.')
          .last,
      'fields': fields,
      'theme': theme?.toJson(),
    };
  }
}

/// Configuration object used for creating an inquiry using a template version
class TemplateIdConfiguration extends _BaseTemplateConfiguration {
  TemplateIdConfiguration({
    required this.templateId,
    super.accountId,
    super.referenceId,
    super.environment = InquiryEnvironment.sandbox,
     this.environmentId,
    super.fields = const {},
    super.theme,
  });

  /// An existing template id that determines how the flow is customized.
  final String templateId;
  final String? environmentId;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateId': templateId,
      'accountId': accountId,
      'referenceId': referenceId,
      'environmentId': environmentId,
       'environment': environment
          .toString()
          .split('.')
          .last,
      'fields': fields,
      'theme': theme?.toJson(),
    };
  }
}

/// Configuration object used for creating an Inquiry using an inquiry ID.
class InquiryIdConfiguration extends InquiryConfiguration {
  InquiryIdConfiguration({
    required this.inquiryId,
    this.sessionToken,
    super.theme,
  });

  /// An existing inquiry.
  final String inquiryId;

  /// Session token for resuming an Inquiry. The token must be generated on the server.
  final String? sessionToken;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'inquiryId': inquiryId,
      'sessionToken': sessionToken,
      'theme': theme?.toJson(),
    };
  }
}
