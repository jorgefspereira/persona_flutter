#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint persona_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'persona_flutter'
  s.version          = '4.1.0'
  s.summary          = 'Persona Inquiry SDK for Flutter'
  s.description      = <<-DESC
Integrate the Persona Inquiry flow directly into your app with native SDK.
                       DESC
  s.homepage         = 'http://github.com/jorgefspereira'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jorge Pereira' => 'jorgefspereira@icloud.com' }
  s.source           = { :path => '.' }
  s.source_files = 'persona_flutter/Sources/persona_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'PersonaInquirySDK2', '2.51.1'
  s.static_framework = true
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
