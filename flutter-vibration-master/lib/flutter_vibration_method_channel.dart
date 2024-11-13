import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_vibration_platform_interface.dart';

/// An implementation of [FlutterVibrationPlatform] that uses method channels.
class MethodChannelFlutterVibration extends FlutterVibrationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_vibration');


  @override
  Future<void> play({String url = "",bool vibration = true}) async {
     await methodChannel.invokeMethod('play',{"uri":url,"vibration":vibration});
  }

  @override
  Future<void> stop() async {
    await methodChannel.invokeMethod('stop');
  }
}
