import 'package:flutter/services.dart';

import '../core/configurations.dart';
import '../core/events.dart';
import 'persona_platform_interface.dart';

class PersonaMethodChannel extends PersonaPlatformInterface {
  /// The method channel used to interact with the native platform.
  final MethodChannel _channel = const MethodChannel('persona_flutter');

  /// The event channel used to receive changes from the native platform.
  final EventChannel _eventChannel =
      const EventChannel('persona_flutter/events');

  /// A broadcast stream from the native platform
  Stream<InquiryEvent>? _stream;

  /// Creates and initializes a new Inquiry object
  @override
  Future<void> init({required InquiryConfiguration configuration}) async {
    return _channel.invokeMethod('init', configuration.toJson());
  }

  /// Starts the verification flow.
  @override
  Future<void> start() async {
    return _channel.invokeMethod('start');
  }

  /// A broadcast stream from the native platform
  @override
  Stream<InquiryEvent> get onEvent {
    _stream ??= _eventChannel.receiveBroadcastStream().map((dynamic event) {
      switch (event['type']) {
        case 'complete':
          return InquiryComplete.fromJson(event);
        case 'error':
          return InquiryError.fromJson(event);
        case 'canceled':
          return InquiryCanceled.fromJson(event);
        default:
          throw MissingPluginException('Event was fired but has no handler');
      }
    });

    return _stream!;
  }
}
