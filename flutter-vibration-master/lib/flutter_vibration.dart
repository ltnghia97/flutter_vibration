import 'dart:io';
import 'package:flutter/services.dart';
import 'flutter_vibration_platform_interface.dart';
import 'package:path_provider/path_provider.dart';

class FlutterVibration {
  Future<void> play({String? assets,bool? vibration}) async{
    String url = await _generateAssetUri(assets);
    return FlutterVibrationPlatform.instance.play(url: url,vibration: vibration??true);
  }
  Future<void> stop() {
    return FlutterVibrationPlatform.instance.stop();
  }

  /// Generate asset uri according to platform.
  static Future<String> _generateAssetUri(String? asset) async {
    if(asset==null || asset.isEmpty){
      return "";
    }
    if (Platform.isAndroid) {
      // read local asset from rootBundle
      final byteData = await rootBundle.load(asset);

      // create a temporary file on the device to be read by the native side
      final file = File('${(await getTemporaryDirectory()).path}/$asset');
      await file.create(recursive: true);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.uri.path;
    } else if (Platform.isIOS) {
      if (!['wav', 'mp3', 'aiff', 'caf']
          .contains(asset.split('.').last.toLowerCase())) {
        throw 'Format not supported for iOS. Only mp3, wav, aiff and caf formats are supported.';
      }
      return asset;
    } else {
      return asset;
    }
  }
}
