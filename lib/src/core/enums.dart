/// The Persona API environment on which to create inquiries.
enum InquiryEnvironment {
  /// The development environment.
  sandbox,

  /// The production environment.
  production
}

/// Source for theme value
enum InquiryThemeSource {
  /// Instructs the SDK to use theme values set in the Persona Dashboard
  server,
 
  /// Uses theme values set on client
  client,
}