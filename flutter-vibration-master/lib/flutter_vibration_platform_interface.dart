import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_vibration_method_channel.dart';

abstract class FlutterVibrationPlatform extends PlatformInterface {
  /// Constructs a FlutterVibrationPlatform.
  FlutterVibrationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterVibrationPlatform _instance = MethodChannelFlutterVibration();

  /// The default instance of [FlutterVibrationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterVibration].
  static FlutterVibrationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterVibrationPlatform] when
  /// they register themselves.
  static set instance(FlutterVibrationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> play({String url = "",bool vibration = true}) {
    return FlutterVibrationPlatform.instance.play(url: url,vibration: vibration);
  }
  Future<void> stop() {
    return FlutterVibrationPlatform.instance.stop();
  }
}
