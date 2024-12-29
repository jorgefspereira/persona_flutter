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
    this.referenceId,
    this.environmentId,
    this.environment,
    this.routingCountry,
    this.fields = const {},
    super.theme,
  });

  /// The identifier can be used to monitor user progress in newly created inquiries.
  final String? referenceId;

  /// The environment id on which to create inquiries.
  final String? environmentId;

  /// The environment on which to create inquiries.
  final InquiryEnvironment? environment;

  /// Any existing user data you want to attach to the inquiry.
  final Map<String, dynamic> fields;

  /// Set the country to route requests to directly. Only set this if you have been instructed to do so by the Persona team.
  final String? routingCountry;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

/// Configuration object used for creating an inquiry using a template version
class TemplateVersionConfiguration extends _BaseTemplateConfiguration {
  TemplateVersionConfiguration({
    required this.templateVersion,
    super.referenceId,
    super.environment,
    super.environmentId,
    super.fields,
    super.theme,
    super.routingCountry,
  });

  /// An existing template version that determines how the flow is customized.
  final String templateVersion;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateVersion': templateVersion,
      'referenceId': referenceId,
      'environmentId': environmentId,
      'environment': environment?.toString().split('.').last,
      'fields': fields,
      'theme': theme?.toJson(),
      'routingCountry': routingCountry,
    };
  }
}

/// Configuration object used for creating an inquiry using a template version
class TemplateIdConfiguration extends _BaseTemplateConfiguration {
  TemplateIdConfiguration({
    required this.templateId,
    super.referenceId,
    super.environment,
    super.environmentId,
    super.fields,
    super.theme,
    super.routingCountry,
  });

  /// An existing template id that determines how the flow is customized.
  final String templateId;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'templateId': templateId,
      'referenceId': referenceId,
      'environmentId': environmentId,
      'environment': environment?.toString().split('.').last,
      'fields': fields,
      'theme': theme?.toJson(),
      'routingCountry': routingCountry,
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
