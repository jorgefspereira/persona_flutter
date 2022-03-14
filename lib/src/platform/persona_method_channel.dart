import 'package:flutter/services.dart';

import '../types/configurations.dart';
import 'persona_platform_interface.dart';

class PersonaMethodChannel extends PersonaPlatformInterface {
  final MethodChannel _channel = const MethodChannel('persona_flutter');

  MethodChannel get channel => _channel;

  PersonaMethodChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Future<void> init({required InquiryConfiguration configuration}) async {
    return _channel.invokeMethod('init', configuration.toJson());
  }

  @override
  Future<void> start() async {
    return _channel.invokeMethod('start');
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onComplete":
        String inquiryId = call.arguments['inquiryId'] as String;
        String status = call.arguments['status'] as String;
        Map<String, dynamic> fields = (call.arguments['fields'] as Map).map(
            (key, value) => MapEntry<String, dynamic>(key.toString(), value));
        onComplete?.call(inquiryId, status, fields);
        break;
      case "onCanceled":
        String? inquiryId = call.arguments['inquiryId'] as String?;
        String? sessionToken = call.arguments['sessionToken'] as String?;
        onCanceled?.call(inquiryId, sessionToken);
        break;
      case "onError":
        String? error = call.arguments['error'] as String?;
        onError?.call(error);
        break;
      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }
}
