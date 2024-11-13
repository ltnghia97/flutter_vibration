import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vibration/flutter_vibration.dart';
import 'package:flutter_vibration/flutter_vibration_platform_interface.dart';
import 'package:flutter_vibration/flutter_vibration_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterVibrationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterVibrationPlatform {

  @override
  Future<void> play({String url = "", bool vibration = true}) {
    // TODO: implement play
    throw UnimplementedError();
  }

  @override
  Future<void> stop() {
    // TODO: implement stop
    throw UnimplementedError();
  }
}

void main() {
  final FlutterVibrationPlatform initialPlatform = FlutterVibrationPlatform.instance;

  test('$MethodChannelFlutterVibration is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterVibration>());
  });

  test('getPlatformVersion', () async {
    FlutterVibration flutterVibrationPlugin = FlutterVibration();
    MockFlutterVibrationPlatform fakePlatform = MockFlutterVibrationPlatform();
    FlutterVibrationPlatform.instance = fakePlatform;

    expect(flutterVibrationPlugin.play(),null);
  });
}
