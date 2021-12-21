import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../types/configurations.dart';
import '../types/typedefs.dart';
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

  /// Called on a successful inquiry.
  InquirySuccessCallback? onSuccess;

  /// Called when the invidual fails the inquiry.
  InquiryFailedCallback? onFailed;

  /// Called when the individual cancels the inquiry.
  InquiryCancelledCallback? onCancelled;

  /// The inquiry errored
  InquiryErrorCallback? onError;

  Future<void> start({required InquiryConfiguration configuration}) async {
    throw UnimplementedError('start() has not been implemented.');
  }
}
