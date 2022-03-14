import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../types/configurations.dart';
import '../types/enums.dart';
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

  /// The inquiry completed
  InquiryCompleteCallback? onComplete;

  /// The inquiry was cancelled by the user
  InquiryCanceledCallback? onCanceled;

  /// The inquiry errored
  InquiryErrorCallback? onError;

  Future<void> init({required InquiryConfiguration configuration}) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> start() async {
    throw UnimplementedError('start() has not been implemented.');
  }
}
