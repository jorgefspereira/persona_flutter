import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../core/configurations.dart';
import '../core/events.dart';
import 'persona_method_channel.dart';

abstract class PersonaPlatformInterface extends PlatformInterface {
  /// Contructor
  PersonaPlatformInterface() : super(token: _token);

  /// Token
  static final Object _token = Object();

  /// Singleton instance
  static PersonaPlatformInterface _instance = PersonaMethodChannel();

  /// Default instance to use.
  static PersonaPlatformInterface get instance => _instance;

  static set instance(PersonaPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream from the native platform
  Stream<InquiryEvent> get onEvent {
    throw UnimplementedError('onEvent has not been implemented.');
  }

  /// Creates and initializes a new Inquiry object
  Future<void> init({required InquiryConfiguration configuration}) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Starts the verification flow.
  Future<void> start() async {
    throw UnimplementedError('start() has not been implemented.');
  }

  /// Disposes of the current inquiry and cleans up resources.
  Future<void> dispose() async {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
