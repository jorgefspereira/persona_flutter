import 'package:flutter/services.dart';
import 'package:persona_flutter/persona_flutter.dart';

import 'persona_platform_interface.dart';

class PersonaMethodChannel extends PersonaPlatformInterface {
  final MethodChannel _channel = const MethodChannel('persona_flutter');

  MethodChannel get channel => _channel;

  PersonaMethodChannel() {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  @override
  Future<void> start({required InquiryConfiguration configuration}) async {
    return _channel.invokeMethod('start', configuration.toJson());
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        final attributes =
            InquiryAttributes.fromJson(call.arguments['attributes']);
        final relationships =
            InquiryRelationships.fromJson(call.arguments['relationships']);
        onSuccess?.call(
            call.arguments['inquiryId'] as String, attributes, relationships);
        break;

      case 'onFailed':
        final attributes =
            InquiryAttributes.fromJson(call.arguments['attributes']);
        final relationships =
            InquiryRelationships.fromJson(call.arguments['relationships']);
        onFailed?.call(
            call.arguments['inquiryId'] as String, attributes, relationships);
        break;

      case 'onCancelled':
        onCancelled?.call();
        break;

      case 'onError':
        onError?.call(call.arguments['error'] as String);
        break;

      default:
        throw MissingPluginException(
            '${call.method} was invoked but has no handler');
    }
  }
}
